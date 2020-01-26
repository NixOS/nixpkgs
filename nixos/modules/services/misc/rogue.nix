# Execute the game `rogue' on tty 9.  Mostly used by the NixOS
# installation CD.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.rogue;

in

{
  ###### interface

  options = {

    services.rogue.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the Rogue game on one of the virtual
        consoles.
      '';
    };

    services.rogue.tty = mkOption {
      type = types.str;
      default = "tty9";
      description = ''
        Virtual console on which to run Rogue.
      '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    console.extraTTYs = [ cfg.tty ];

    systemd.services.rogue =
      { description = "Rogue dungeon crawling game";
        wantedBy = [ "multi-user.target" ];
        serviceConfig =
          { ExecStart = "${pkgs.rogue}/bin/rogue";
            StandardInput = "tty";
            StandardOutput = "tty";
            TTYPath = "/dev/${cfg.tty}";
            TTYReset = true;
            TTYVTDisallocate = true;
            WorkingDirectory = "/tmp";
            Restart = "always";
          };
      };

  };

}
