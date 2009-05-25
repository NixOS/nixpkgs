{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.desktopManager.gnome;
  gnome = pkgs.gnome;

  options = { services = { xserver = { desktopManager = {

    gnome = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable a gnome terminal as a desktop manager.";
      };
    };

  }; }; }; };
in

mkIf cfg.enable {
  require = options;

  services = {
    xserver = {

      desktopManager = {
        session = [{
          name = "gnome";
          start = ''
            ${gnome.gnometerminal}/bin/gnome-terminal -ls &
            waitPID=$!
          '';
        }];
      };

    };
  };

  environment = {
    extraPackages = [
      gnome.gnometerminal
      gnome.GConf
      gnome.gconfeditor
    ];
  };
}
