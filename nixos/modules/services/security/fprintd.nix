{ config, lib, pkgs, ... }:
let

  cfg = config.services.fprintd;
  fprintdPkg = if cfg.tod.enable then pkgs.fprintd-tod else pkgs.fprintd;

in


{

  ###### interface

  options = {

    services.fprintd = {

      enable = lib.mkEnableOption "fprintd daemon and PAM module for fingerprint readers handling";

      package = lib.mkOption {
        type = lib.types.package;
        default = fprintdPkg;
        defaultText = lib.literalExpression "if config.services.fprintd.tod.enable then pkgs.fprintd-tod else pkgs.fprintd";
        description = ''
          fprintd package to use.
        '';
      };

      tod = {

        enable = lib.mkEnableOption "Touch OEM Drivers library support";

        driver = lib.mkOption {
          type = lib.types.package;
          example = lib.literalExpression "pkgs.libfprint-2-tod1-goodix";
          description = ''
            Touch OEM Drivers (TOD) package to use.
          '';
        };
      };

      lid = {
        authSkipLidClose = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Disable fprint auth when laptop with built-in fingerprint reader has lid closed. Useful for docked laptops.
          '';
        };
        path = lib.mkOption {
          type = lib.types.str;
          default = "/proc/acpi/button/lid/LID/state";
          example = "/proc/acpi/button/lid/LID/state";
          description = ''
            Path to lid state file.
          '';
        };
      };
    };
  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    services.dbus.packages = [ cfg.package ];

    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.fprintd.environment = lib.mkIf cfg.tod.enable {
      FP_TOD_DRIVERS_DIR = "${cfg.tod.driver}${cfg.tod.driver.driverPath}";
    };

  };

}
