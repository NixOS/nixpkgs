{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "duosec";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = ''
        If set, use the Duo Security pam module
        <literal>pam_duo</literal> for authentication.  Requires
        configuration of <option>security.duosec</option> options.
      '';
    };
  };

  mkAuthConfig = svcCfg: {
    ${name} = {
      control = "required";
      path = "${pkgs.duo-unix}/lib/security/pam_duo.so";
      order = 28000;
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
