{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "otpw";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = ''
        Whether to enable the OTPW (one-time password) PAM module.
        If true, the OTPW system will be used (if <filename>~/.otpw</filename>
        exists).
      '';
    };
  };

  path = "${pkgs.otpw}/lib/security/pam_otpw.so";

  mkAuthConfig = svcCfg: {
    ${name} = {
      inherit path;
      control = "sufficient";
      order = 31000;
    };
  };

  mkSessionConfig = svcCfg: {
    ${name} = {
      inherit path;
      control = "optional";
      order = 10000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkAuthConfig mkSessionConfig;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable;
    };
  };

  config = mkIf (modCfg.enable || (utils.pam.anyEnable pamCfg name)) {
    environment.systemPackages = [ pkgs.otpw ];
  };
}
