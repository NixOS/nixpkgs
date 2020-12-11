{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "googleAuthenticator";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = ''
        If set, users with enabled Google Authenticator (created
        <filename>~/.google_authenticator</filename>) will be required
        to provide Google Authenticator token to log in.
      '';
    };
  };

  mkAuthConfig = svcCfg: {
    ${name} = {
      control = "required";
      path = "${pkgs.googleAuthenticator}/lib/security/pam_google_authenticator.so";
      args = [ "no_increment_hotp" ];
      order = 27000;
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
