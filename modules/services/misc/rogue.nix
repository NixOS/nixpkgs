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
  
    jobs.rogue =
      { description = "Rogue dungeon crawling game";

        startOn = "started udev";

        extraConfig = "chdir /root";

        exec = "${pkgs.rogue}/bin/rogue < /dev/${cfg.tty} > /dev/${cfg.tty} 2>&1";
      };

    services.ttyBackgrounds.specificThemes = singleton
      { tty = cfg.tty;
        theme = pkgs.themes "theme-gnu";
      };

  };
    
}
