{ config, pkgs, ... }:

###### implementation

{
  jobs.control_alt_delete =
    { name = "control-alt-delete";

      startOn = "control-alt-delete";

      task = true;

      script =
        ''
          shutdown -r now 'Ctrl-Alt-Delete pressed'
        '';
    };
}
