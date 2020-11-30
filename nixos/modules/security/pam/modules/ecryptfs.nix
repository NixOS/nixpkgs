{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "ecryptfs";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = ''
        Whether to enable the eCryptfs (one-time password) PAM module (mounting
        ecryptfs home directory on login).
      '';
    };
  };

  control = "optional";
  path = "${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so";

  mkAuthConfig = svcCfg: {
    ${name} = {
      inherit control path;
      args = [ "unwrap" ];
      order = 22000;
    };
  };

  mkPasswordConfig = svcCfg: {
    ${name} = {
      inherit control path;
      order = 2000;
    };
  };

  mkSessionConfig = svcCfg: {
    ${name} = {
      inherit control path;
      order = 5000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkAuthConfig mkPasswordConfig mkSessionConfig;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable;
    };
  };

  config = mkIf (modCfg.enable || (utils.pam.anyEnable pamCfg name)) {
    boot.supportedFilesystems = [ "ecryptfs" ];
  };
}
