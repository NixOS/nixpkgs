{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.sssd;
  nscd = config.services.nscd;
in {
  options = {
    services.sssd = {
      enable = mkEnableOption "the System Security Services Daemon.";

      config = mkOption {
        type = types.lines;
        description = "Contents of <filename>sssd.conf</filename>.";
        default = ''
          [sssd]
          config_file_version = 2
          services = nss, pam
          domains = shadowutils

          [nss]

          [pam]

          [domain/shadowutils]
          id_provider = proxy
          proxy_lib_name = files
          auth_provider = proxy
          proxy_pam_target = sssd-shadowutils
          proxy_fast_alias = True
        '';
      };

      sshAuthorizedKeysIntegration = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to make sshd look up authorized keys from SSS.
          For this to work, the <literal>ssh</literal> SSS service must be enabled in the sssd configuration.
        '';
      };
    };
  };
  config = mkMerge [
    (mkIf cfg.enable {
      assertions = singleton {
        assertion = nscd.enable;
        message = "nscd must be enabled through `services.nscd.enable` for SSSD to work.";
      };

      systemd.services.sssd = {
        description = "System Security Services Daemon";
        wantedBy    = [ "multi-user.target" ];
        before = [ "systemd-user-sessions.service" "nss-user-lookup.target" ];
        after = [ "network-online.target" "nscd.service" ];
        requires = [ "network-online.target" "nscd.service" ];
        wants = [ "nss-user-lookup.target" ];
        restartTriggers = [
          config.environment.etc."nscd.conf".source
          config.environment.etc."sssd/sssd.conf".source
        ];
        script = ''
          export LDB_MODULES_PATH+="''${LDB_MODULES_PATH+:}${pkgs.ldb}/modules/ldb:${pkgs.sssd}/modules/ldb"
          mkdir -p /var/lib/sss/{pubconf,db,mc,pipes,gpo_cache,secrets} /var/lib/sss/pipes/private /var/lib/sss/pubconf/krb5.include.d
          ${pkgs.sssd}/bin/sssd -D
        '';
        serviceConfig = {
          Type = "forking";
          PIDFile = "/run/sssd.pid";
        };
      };

      environment.etc."sssd/sssd.conf" = {
        text = cfg.config;
        mode = "0400";
      };

      system.nssModules = optional cfg.enable pkgs.sssd;
      services.dbus.packages = [ pkgs.sssd ];
    })

    (mkIf cfg.sshAuthorizedKeysIntegration {
    # Ugly: sshd refuses to start if a store path is given because /nix/store is group-writable.
    # So indirect by a symlink.
    environment.etc."ssh/authorized_keys_command" = {
      mode = "0755";
      text = ''
        #!/bin/sh
        exec ${pkgs.sssd}/bin/sss_ssh_authorizedkeys "$@"
      '';
    };
    services.openssh.extraConfig = ''
      AuthorizedKeysCommand /etc/ssh/authorized_keys_command
      AuthorizedKeysCommandUser nobody
    '';
  })];
}
