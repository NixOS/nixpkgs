{ config, lib, pkgs, ... }:

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

  };

  config = mkIf cfg.enable {
    security.pam.services.sshd = {
      makeHomeDir = true;
      googleOsLoginAccountVerification = true;
      # disabled for now: googleOsLoginAuthentication = true;
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
