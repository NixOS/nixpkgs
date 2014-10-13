{pkgs, ...}:
{
  ###### interface
  options = {
  };


  ###### implementation
  vimrc = cfg:
    ''
    " Always show the status line
    set laststatus=2

    " Height of the command bar
    set cmdheight=1
    '';

  plugins = [ "airline" ];

  paths = [];
}

