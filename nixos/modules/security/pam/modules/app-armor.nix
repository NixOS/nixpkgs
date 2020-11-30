{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "apparmor";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = ''
        Enable support for attaching AppArmor profiles at the
        user/group level, e.g., as part of a role based access
        control scheme.
      '';
    };
  };

  mkSessionConfig = svcCfg: {
    ${name} = {
      control = "optional";
      path = "${pkgs.apparmor-pam}/lib/security/pam_apparmor.so";
      args = [
        "order=user,group,default"
        "debug"
      ];
      order = 15000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkSessionConfig;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable && config.security.apparmor.enable;
    };
  };
}
