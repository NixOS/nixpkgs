{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "googleOsLogin";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enableAccountVerification = mkOption {
      default = if global then false else modCfg.enableAccountVerification;
      type = types.bool;
      description = ''
        If true, will use the Google OS Login PAM modules
        (<literal>pam_oslogin_login</literal>,
        <literal>pam_oslogin_admin</literal>) to verify possible OS Login
        users and set sudoers configuration accordingly.
        This only makes sense to enable for the <literal>sshd</literal> PAM
        service.
      '';
    };

    enableAuthentication = mkOption {
      default = if global then false else modCfg.enableAuthentication;
      type = types.bool;
      description = ''
        If true, will use the <literal>pam_oslogin_login</literal>'s user
        authentication methods to authenticate users using 2FA.
        This only makes sense to enable for the <literal>sshd</literal> PAM
        service.
      '';
    };
  };

  path = "${pkgs.google-compute-engine-oslogin}/lib/pam_oslogin_login.so";

  mkAccountConfig = svcCfg: let cond = svcCfg.modules.${name}.enableAccountVerification; in {
    "${name}Die" = mkIf cond {
      inherit path;
      control = { success = "ok"; ignore = "ignore"; default = "die"; };
      order = 10000;
    };
    "${name}Ignore" = mkIf cond {
      inherit path;
      control = { success = "ok"; default = "ignore"; };
      order = 10500;
    };
  };

  mkAuthConfig = svcCfg: {
    ${name} = mkIf svcCfg.modules.${name}.enableAuthentication {
      inherit path;
      control = { success = "done";  perm_denied = "bad";  default = "ignore"; };
      order = 10000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkAccountConfig mkAuthConfig;
    };
  };
}
