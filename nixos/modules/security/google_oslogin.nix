{ config, lib, pkgs, utils, ... }:

with lib;

let

  cfg = config.security.googleOsLogin;
  package = pkgs.google-compute-engine-oslogin;

in

{

  options = {

    security.googleOsLogin.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable Google OS Login

        The OS Login package enables the following components:
        AuthorizedKeysCommand to query valid SSH keys from the user's OS Login
        profile during ssh authentication phase.
        NSS Module to provide user and group information
        PAM Module for the sshd service, providing authorization and
        authentication support, allowing the system to use data stored in
        Google Cloud IAM permissions to control both, the ability to log into
        an instance, and to perform operations as root (sudo).
      '';
    };

    security.pam =
      let
        name = "googleOsLogin";
        pamCfg = config.security.pam;
        modCfg = pamCfg.modules.${name};
        path = "${package}/lib/pam_oslogin_login.so";
      in
      utils.pam.mkPamModule {
        inherit name;

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

        mkAccountConfig = svcCfg: mkIf svcCfg.modules.${name}.enableAccountVerification {
          "${name}Die" = {
            inherit path;
            control = { success = "ok"; ignore = "ignore"; default = "die"; };
            order = 10000;
          };
          "${name}Ignore" = {
            inherit path;
            control = { success = "ok"; default = "ignore"; };
            order = 10500;
          };
        };

        mkAuthConfig = svcCfg: mkIf svcCfg.modules.${name}.enableAuthentication {
          ${name} = {
            inherit path;
            control = { success = "done";  perm_denied = "bad";  default = "ignore"; };
            order = 10000;
          };
        };
      };

  };

  config = mkIf cfg.enable {
    security.pam.services.sshd.modules = {
      makeHomeDir.enable = true;
      googleOsLogin.enableAccountVerification = true;
      # disabled for now: googleOs.enableAuthentication = true;
    };

    security.sudo.extraConfig = ''
      #includedir /run/google-sudoers.d
    '';
    systemd.tmpfiles.rules = [
      "d /run/google-sudoers.d 750 root root -"
      "d /var/google-users.d 750 root root -"
    ];

    # enable the nss module, so user lookups etc. work
    system.nssModules = [ package ];
    system.nssDatabases.passwd = [ "cache_oslogin" "oslogin" ];
    system.nssDatabases.group = [ "cache_oslogin" "oslogin" ];

    # Ugly: sshd refuses to start if a store path is given because /nix/store is group-writable.
    # So indirect by a symlink.
    environment.etc."ssh/authorized_keys_command_google_oslogin" = {
      mode = "0755";
      text = ''
        #!/bin/sh
        exec ${package}/bin/google_authorized_keys "$@"
      '';
    };
    services.openssh.authorizedKeysCommand = "/etc/ssh/authorized_keys_command_google_oslogin %u";
    services.openssh.authorizedKeysCommandUser = "nobody";
  };

}
