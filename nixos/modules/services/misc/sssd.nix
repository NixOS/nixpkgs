{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.sssd;
  nscd = config.services.nscd;

  dataDir = "/var/lib/sssd";
  settingsFile = "${dataDir}/sssd.conf";
  settingsFileUnsubstituted = pkgs.writeText "${dataDir}/sssd-unsubsituted.conf" cfg.config;
in {
  options = {
    services.sssd = {
      enable = mkEnableOption "the System Security Services Daemon";

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
      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Environment file as defined in <citerefentry>
          <refentrytitle>systemd.exec</refentrytitle><manvolnum>5</manvolnum>
          </citerefentry>.

          Secrets may be passed to the service without adding them to the world-readable
          Nix store, by specifying placeholder variables as the option value in Nix and
          setting these variables accordingly in the environment file.

          <programlisting>
            # snippet of sssd-related config
            [domain/LDAP]
            ldap_default_authtok = $SSSD_LDAP_DEFAULT_AUTHTOK
          </programlisting>

          <programlisting>
            # contents of the environment file
            SSSD_LDAP_DEFAULT_AUTHTOK=verysecretpassword
          </programlisting>
        '';
      };
    };
  };
  config = mkMerge [
    (mkIf cfg.enable {
      systemd.services.sssd = {
        description = "System Security Services Daemon";
        wantedBy    = [ "multi-user.target" ];
        before = [ "systemd-user-sessions.service" "nss-user-lookup.target" ];
        after = [ "network-online.target" "nscd.service" ];
        requires = [ "network-online.target" "nscd.service" ];
        wants = [ "nss-user-lookup.target" ];
        restartTriggers = [
          config.environment.etc."nscd.conf".source
          settingsFileUnsubstituted
        ];
        script = ''
          export LDB_MODULES_PATH+="''${LDB_MODULES_PATH+:}${pkgs.ldb}/modules/ldb:${pkgs.sssd}/modules/ldb"
          mkdir -p /var/lib/sss/{pubconf,db,mc,pipes,gpo_cache,secrets} /var/lib/sss/pipes/private /var/lib/sss/pubconf/krb5.include.d
          ${pkgs.sssd}/bin/sssd -D -c ${settingsFile}
        '';
        serviceConfig = {
          Type = "forking";
          PIDFile = "/run/sssd.pid";
          StateDirectory = baseNameOf dataDir;
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        };
        preStart = ''
          [ -f ${settingsFile} ] && rm -f ${settingsFile}
          old_umask=$(umask)
          umask 0177
          ${pkgs.envsubst}/bin/envsubst \
            -o ${settingsFile} \
            -i ${settingsFileUnsubstituted}
          umask $old_umask
        '';
      };

      system.nssModules = [ pkgs.sssd ];
      system.nssDatabases = {
        group = [ "sss" ];
        passwd = [ "sss" ];
        services = [ "sss" ];
        shadow = [ "sss" ];
      };
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
    services.openssh.authorizedKeysCommand = "/etc/ssh/authorized_keys_command";
    services.openssh.authorizedKeysCommandUser = "nobody";
  })];

  meta.maintainers = with maintainers; [ bbigras ];
}
