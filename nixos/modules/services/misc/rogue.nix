# Execute the game `rogue' on tty 9.  Mostly used by the NixOS
# installation CD.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.rogue;

in

{
  ###### interface

  options = {

    services.rogue.enable = mkOption {
      default = false;
      description = ''
        Whether to enable the Rogue game on one of the virtual
        consoles.
      '';
    };

    services.rogue.tty = mkOption {
      default = "tty9";
      description = ''
        Virtual console on which to run Rogue.
      '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    boot.extraTTYs = [ cfg.tty ];

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
            Restart = "always";
          };
      };

  };

}
