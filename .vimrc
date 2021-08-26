" The default vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2017 Jun 13
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on
  " shiftwidth is, for example, used in >> to determine how many "spaces" to
  " increase the line by.
  " tabstop is the width of a \t, measured in spaces.
  " expandtab replaces \t with spaces
  autocmd FileType dart setlocal shiftwidth=2 tabstop=2 expandtab smarttab
  autocmd FileType javascript setlocal shiftwidth=4 tabstop=4
  autocmd FileType html setlocal shiftwidth=4 tabstop=4
  autocmd FileType c setlocal shiftwidth=4 tabstop=4
  autocmd FileType typescript setlocal shiftwidth=4 tabstop=4
  autocmd FileType java setlocal shiftwidth=4 tabstop=4
  autocmd FileType go setlocal shiftwidth=4 tabstop=4
  autocmd FileType json setlocal shiftwidth=4 tabstop=4
  autocmd FileType typescriptreact setlocal shiftwidth=4 tabstop=4

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

  "augroup matchup_matchparen_highlight
	"autocmd!

	"autocmd ColorScheme * hi MatchParen guibg=gray ctermbg=gray
	"autocmd ColorScheme * hi MatchWord guibg=gray ctermbg=gray
  "augroup END

endif " has("autocmd")

" modify the matching colorscheme
hi MatchParen guibg=gray ctermbg=gray
hi MatchWord guibg=gray ctermbg=gray
hi MatchParenCur guibg=gray ctermbg=gray gui=underline cterm=underline
hi MatchWordCur guibg=gray ctermbg=gray gui=bold cterm=bold

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" For vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Can also use shorthand: 'Valloric/YouCompleteMe'
Plug 'https://github.com/ycm-core/YouCompleteMe.git'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'dart-lang/dart-vim-plugin'
Plug 'Valloric/ListToggle'
Plug 'udalov/kotlin-vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'andymass/vim-matchup'
Plug 'mbbill/undotree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

call plug#end()

" YouCompleteMe settings
let g:ycm_always_populate_location_list = 1
" let g:ycm_server_python_interpreter = '/usr/bin/python3.8'
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/global_extra_conf.py'

" ListToggle settings
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'
let g:lt_height = 10

nnoremap ,c  :pclose<CR>
nnoremap ,nh :nohlsearch<CR>

" YouCompleteMe shortcuts
nnoremap ,f  :YcmCompleter FixIt<CR>
nnoremap ,d  :YcmCompleter GetDoc<CR>
nnoremap ,t  :YcmCompleter GetType<CR>
nnoremap ,fm :YcmCompleter Format<CR>
nnoremap ,g  :YcmCompleter GoTo<CR>
nnoremap ,gf :YcmCompleter GoToDefinition<CR>
nnoremap ,gd :YcmCompleter GoToDeclaration<CR>
nnoremap ,rf :YcmCompleter GoToReferences<CR>
cnoremap rr YcmCompleter RefactorRename

" undotree shortcuts
nnoremap \u  :UndotreeToggle<CR>

set iskeyword-=_
set hlsearch

