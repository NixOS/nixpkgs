{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.fprintd;
  fprintdPkg = if cfg.tod.enable then pkgs.fprintd-tod else pkgs.fprintd;

in


{

  ###### interface

  options = {

    services.fprintd = {

      enable = mkEnableOption "fprintd daemon and PAM module for fingerprint readers handling";

      package = mkOption {
        type = types.package;
        default = fprintdPkg;
        defaultText = literalExpression "if config.services.fprintd.tod.enable then pkgs.fprintd-tod else pkgs.fprintd";
        description = ''
          fprintd package to use.
        '';
      };

      tod = {

        enable = mkEnableOption "Touch OEM Drivers library support";

        driver = mkOption {
          type = types.package;
          example = literalExpression "pkgs.libfprint-2-tod1-goodix";
          description = ''
            Touch OEM Drivers (TOD) package to use.
          '';
        };
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    services.dbus.packages = [ cfg.package ];

    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.fprintd.environment = mkIf cfg.tod.enable {
      FP_TOD_DRIVERS_DIR = "${cfg.tod.driver}${cfg.tod.driver.driverPath}";
    };

  };

}
