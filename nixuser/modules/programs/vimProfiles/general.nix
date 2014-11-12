{pkgs,...}:
{
  ###### interface
  options = {
    spell = {
      default = "<Leader>cc";
      description = "Toggle spell checking.";
    };
  };


  ###### implementation
  vimrc = cfg: ''
    " Set utf8 as standard encoding and en_US as the standard language
    set encoding=utf8
    
    " Always show current position
    set ruler
    set number
    
    " Enable syntax highlighting
    syntax enable
    
    " Enable filetype plugins
    filetype plugin on
    filetype indent on

    "use mouse everywhere
    set mouse=a

    " Disable error bells
    set noerrorbells
    set novisualbell
    set vb t_vb=
    
    " Use Unix as the standard file type
    set ffs=unix,dos,mac
    
    " Set to auto read when a file is changed from the outside
    set autoread
    
    " Show trailing whitespace
    set list
    " But only interesting whitespace
    if &listchars ==# "eol:$"
      set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    endif
    
    " Configure backspace so it acts as it should act
    set backspace=eol,start,indent
    set whichwrap+=<,>,h,l
    
    " Don't redraw while executing macros (good performance config)
    set lazyredraw
    
    
    " Return to last edit position when opening files (You want this!)
    augroup last_edit
      autocmd!
      autocmd BufReadPost *
           \ if line("'\"") > 0 && line("'\"") <= line("$") |
           \   exe "normal! g\`\"" |
           \ endif
    augroup END
    " Remember info about open buffers on close
    set viminfo^=%
    
    '' + (if isNull cfg.spell then "" else ''
    " Toggle and untoggle spell checking
    map ${cfg.spell} :setlocal spell!<cr>
    '');

  plugins = [];

  paths = [];
}

