{ config, pkgs, ... }:

###### implementation

{
  jobs.ctrl_alt_delete =
    { name = "ctrl-alt-delete";

      startOn = "ctrlaltdel";

      task = true;

      script =
        ''
          shutdown -r now 'Ctrl-Alt-Delete pressed'
        '';
    };
}
