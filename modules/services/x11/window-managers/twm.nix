{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.windowManager.twm;
  xorg = pkgs.xorg;

  option = { services = { xserver = { windowManager = {

    twm = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the twm window manager.";
      };

    };

  }; }; }; };
in

mkIf cfg.enable {
  require = option;

  services = {
    xserver = {

      windowManager = {
        session = [{
          name = "twm";
          start = "
            ${xorg.twm}/bin/twm &
            waitPID=$!
          ";
        }];
      };

    };
  };

  environment = {
    x11Packages = [ xorg.twm ];
  };
}
