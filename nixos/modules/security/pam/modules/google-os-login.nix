{ config, pkgs, lib, ... }:

# TODO: move this to google-os-login

with lib;

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.googleOsLogin;

  moduleOptions = global: {
    enableAccountVerification = mkOption {
      default = if global then false else cfg.enableAccountVerification;
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
      default = if global then false else cfg.enableAuthentication;
      type = types.bool;
      description = ''
        If true, will use the <literal>pam_oslogin_login</literal>'s user
        authentication methods to authenticate users using 2FA.
        This only makes sense to enable for the <literal>sshd</literal> PAM
        service.
      '';
    };
  };
in
{
  options = {
    security.pam = {
      services = mkOption {
        type = with types; attrsOf (submodule
          ({ config, ... }: {
            options = {
              modules.googleOsLogin = moduleOptions false;
            };

            config = {
              account = mkIf config.modules.googleOsLogin.enableAccountVerification {
                googleOsLoginDie = {
                  control = { success = "ok"; ignore = "ignore"; default = "die"; };
                  path = "${pkgs.google-compute-engine-oslogin}/lib/pam_oslogin_login.so";
                  order = 10000;
                };
                googleOsLoginIgnore = {
                  control = { success = "ok"; default = "ignore"; };
                  path = "${pkgs.google-compute-engine-oslogin}/lib/pam_oslogin_admin.so";
                  order = 10500;
                };
              };

              auth.googleOsLogin = mkIf config.modules.googleOsLogin.enableAuthentication {
                control = { success = "done";  perm_denied = "bad";  default = "ignore"; };
                path = "${pkgs.google-compute-engine-oslogin}/lib/pam_oslogin_login.so";
                order = 10000;
              };
            };
          })
        );
      };

      modules.googleOsLogin = moduleOptions true;
    };
  };
}
