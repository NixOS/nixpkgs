{ config, lib, pkgs, utils, ... }:

with lib;

let

  cfg = config.services.fprintd;

in


{

  ###### interface

  options = {

    services.fprintd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable fprintd daemon and PAM module for fingerprint readers handling.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.fprintd;
        defaultText = "pkgs.fprintd";
        description = ''
          fprintd package to use.
        '';
      };

    };

    security.pam =
      let
        name = "fprintd";
        pamCfg = config.security.pam;
        modCfg = pamCfg.modules.${name};
      in
      utils.pam.mkPamModule {
        inherit name;
        mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable;

        mkModuleOptions = global: {
          enable = mkOption {
            default = if global then cfg.enable else modCfg.enable;
            type = types.bool;
            description = ''
              If true, fingerprint reader will be used (if exists and
              your fingerprints are enrolled).
            '';
          };
        };

        mkAuthConfig = svcCfg: {
          ${name} = {
            control = "sufficient";
            path = "${cfg.package}/lib/security/pam_fprintd.so";
            order = 15000;
          };
        };
      };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.dbus.packages = [ pkgs.fprintd ];

    environment.systemPackages = [ pkgs.fprintd ];

    systemd.packages = [ cfg.package ];

  };

}
