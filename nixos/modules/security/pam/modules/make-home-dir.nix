{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "makeHomeDir";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = ''
        Whether to try to create home directories for users
        with <literal>$HOME</literal>s pointing to nonexistent
        locations on session login.
      '';
    };

    skelDirectory = mkOption {
      type = types.str;
      default = if global then "/var/empty" else modCfg.skelDirectory;
      example =  "/etc/skel";
      description = ''
        Path to skeleton directory whose contents are copied to home
        directories newly created by <literal>pam_mkhomedir</literal>.
      '';
    };
  };

  mkSessionConfig = svcCfg: {
    ${name} = {
      control = "required";
      path = "${pkgs.pam}/lib/security/pam_mkhomedir.so";
      args = [
        "silent"
        "skel=${svcCfg.modules.${name}.skelDirectory}"
        "umask=0022"
      ];
      order = 3000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkSessionConfig;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable;
    };
  };
}
