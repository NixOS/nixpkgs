{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "fprintd";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then config.services.fprintd.enable else modCfg.enable;
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
      path = "${config.services.fprintd.package}/lib/security/pam_fprintd.so";
      order = 15000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkAuthConfig;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable;
    };
  };
}
