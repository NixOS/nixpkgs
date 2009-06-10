{pkgs, config, ...}: 

# Show rogue game on tty8
# Originally used only by installation CD

let
  inherit (pkgs.lib) mkOption;
  options = {
    services = {
      rogue = {
        enable = mkOption {
	  default = false;
	  description = "
	    Whether to run rogue
	  ";
	};
	ttyNumber = mkOption {
	  default = "8";
	  description = "
	    TTY number name to show the manual on
	  ";
	};
      };
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
        description "rogue game"
	
        start on udev
        stop on shutdown

        respawn ${pkgs.rogue}/bin/rogue < /dev/tty${toString cfg.ttyNumber} > /dev/tty${toString cfg.ttyNumber} 2>&1
      '';
    };

  services.ttyBackgrounds.specificThemes = pkgs.lib.singleton
    { tty = cfg.ttyNumber;
      theme = pkgs.themes "theme-gnu";
    };

  services.mingetty.helpLine = "\nPress <Alt-F${toString cfg.ttyNumber}> to play Rogue.";
}
