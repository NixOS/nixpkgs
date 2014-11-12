{pkgs, ...}:
{
  ###### interface
  options = {
    alignEqual = {
      default = "<Leader>a=";
      description = "Keymap to align on equal sign.";
    };

    alignComma = {
      default = "<Leader>a,";
      description = "Keymap to align on comma.";
    };

    alignBar = {
      default = "<Leader>a<bar>";
      description = "Keymap to align on '|'.";
    };

    alignPrompt = {
      default = "<Leader>ap";
      description = "Prompt for alignment key, and then align on that key.";
    };

    deleteWS = {
      default = "<Leader>dw";
      description = "Keymap to delete trailing whitespace.";
    };
  };


  ###### implementation
  vimrc = cfg:
    ''
    " Use spaces instead of tabs
    set expandtab

    " Be smart when using tabs ;)
    set smarttab

    " 1 tab == 2 spaces
    set shiftwidth=2
    set tabstop=2

    " Linebreak on 500 characters
    set lbr
    set tw=500

    " Auto indent
    set ai
    " Smart indent
    set si 
    " Wrap lines
    set wrap


    " Stop Align plugin from forcing its mappings on us
    let g:loaded_AlignMapsPlugin=1
    '' + (if isNull cfg.alignEqual then "" else ''
    " Align on equal signs
    map ${cfg.alignEqual} :Align =<CR>
    '') + (if isNull cfg.alignComma then "" else ''
    " Align on commas
    map ${cfg.alignComma} :Align ,<CR>
    '') + (if isNull cfg.alignBar then "" else ''
    " Align on bars
    map ${cfg.alignBar} :Align <bar><CR>
    '') + (if isNull cfg.alignPrompt then "" else ''
    " Prompt for align character
    map ${cfg.alignPrompt} :Align 
    '') + ''

    '' + (if isNull cfg.deleteWS then "" else ''
    " Delete trailing white space
    func! DeleteTrailingWS()
      exe "normal mz"
      %s/\s\+$//ge
      exe "normal \`z"
    endfunc

    map ${cfg.deleteWS} :call DeleteTrailingWS<CR>
    '');

  plugins = [ "tabular" "align" "commentary" ];

  paths = [];
}



