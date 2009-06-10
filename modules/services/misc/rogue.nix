{pkgs, config, ...}: 

# Show rogue game on tty9
# Originally used only by installation CD

let

  inherit (pkgs.lib) mkOption;
  
  options = {
  
    services.rogue.enable = mkOption {
      default = false;
      description = ''
        Whether to enable the Rogue game on one of the virtual
        consoles.
      '';
    };

    services.rogue.ttyNumber = mkOption {
      default = "9";
      description = ''
        Virtual console on which to run Rogue.
      '';
    };

  };
  
  cfg = config.services.rogue;

in

pkgs.lib.mkIf cfg.enable {
  require = [options];

  boot.extraTTYs = [cfg.ttyNumber];
  
  services.extraJobs = pkgs.lib.singleton
    { name = "rogue";

      job = ''
        description "Rogue dungeon crawling game"
	
        start on udev
        stop on shutdown

        chdir /root

        respawn ${pkgs.rogue}/bin/rogue < /dev/tty${toString cfg.ttyNumber} > /dev/tty${toString cfg.ttyNumber} 2>&1
      '';
    };

  services.ttyBackgrounds.specificThemes = pkgs.lib.singleton
    { tty = cfg.ttyNumber;
      theme = pkgs.themes "theme-gnu";
    };

  services.mingetty.helpLine = "\nPress <Alt-F${toString cfg.ttyNumber}> to play Rogue.";
}
