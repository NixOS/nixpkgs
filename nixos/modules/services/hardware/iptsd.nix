{ config, lib, pkgs, ... }:

let
  cfg = config.services.iptsd;
  format = pkgs.formats.ini { };
  configFile = format.generate "iptsd.conf" cfg.config;
in {
  options.services.iptsd = {
    enable = lib.mkEnableOption "the userspace daemon for Intel Precise Touch & Stylus";

    config = lib.mkOption {
      default = { };
      description = ''
        Configuration for IPTSD. See the
        [reference configuration](https://github.com/linux-surface/iptsd/blob/master/etc/iptsd.conf)
        for available options and defaults.
      '';
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          Touch = {
            DisableOnPalm = lib.mkOption {
              default = false;
              description = "Ignore all touch inputs if a palm was registered on the display.";
              type = lib.types.bool;
            };
            DisableOnStylus = lib.mkOption {
              default = false;
              description = "Ignore all touch inputs if a stylus is in proximity.";
              type = lib.types.bool;
            };
          };
          Stylus = {
            Disable = lib.mkOption {
              default = false;
              description = "Disables the stylus. No stylus data will be processed.";
              type = lib.types.bool;
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ pkgs.iptsd ];
    environment.etc."iptsd.conf".source = configFile;
    systemd.services."iptsd@".restartTriggers = [ configFile ];
    services.udev.packages = [ pkgs.iptsd ];
  };

  meta.maintainers = with lib.maintainers; [ dotlambda ];
}
