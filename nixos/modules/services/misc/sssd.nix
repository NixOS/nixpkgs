{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.sssd;
  settingsFormat = pkgs.formats.ini { };

  dataDir = "/var/lib/sssd";
  settingsFile = "${dataDir}/sssd.conf";
  mkSettingsFileUnsubstituted =
    settings:
    let
      pyBool = x: if x then "True" else "False";
      finalSettings = lib.mapAttrs (
        _: lib.mapAttrs (_: v: if lib.isBool v then pyBool v else v)
      ) settings;
    in
    settingsFormat.generate "sssd-unsubstituted.conf" finalSettings;
  settingsFileUnsubstituted =
    if cfg.settings == { } then
      pkgs.writeText "sssd-unsubstituted.conf" cfg.config
    else
      mkSettingsFileUnsubstituted cfg.settings;
in
{
  options = {
    services.sssd = {
      enable = lib.mkEnableOption "the System Security Services Daemon";

      settings = lib.mkOption {
        inherit (settingsFormat) type;
        description = "Contents of {file}`sssd.conf`.";
        default = { };
        example = {
          sssd = {
            services = "nss, pam";
            domains = "shadowutils";
          };

          nss = { };

          pam = { };

          "domain/shadowutils" = {
            id_provider = "proxy";
            proxy_lib_name = "files";
            auth_provider = "proxy";
            proxy_pam_target = "sssd-shadowutils";
            proxy_fast_alias = true;
          };
        };
      };

      config = lib.mkOption {
        type = lib.types.lines;
        description = "Contents of {file}`sssd.conf`.";
        default = "";
        example = ''
          [sssd]
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

      sshAuthorizedKeysIntegration = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to make sshd look up authorized keys from SSS.
          For this to work, the `ssh` SSS service must be enabled in the sssd configuration.
        '';
      };

      kcm = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to use SSS as a Kerberos Cache Manager (KCM).
          Kerberos will be configured to cache credentials in SSS.
        '';
      };
      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Environment file as defined in {manpage}`systemd.exec(5)`.

          Secrets may be passed to the service without adding them to the world-readable
          Nix store, by specifying placeholder variables as the option value in Nix and
          setting these variables accordingly in the environment file.

          ```
            # snippet of sssd-related config
            [domain/LDAP]
            ldap_default_authtok = $SSSD_LDAP_DEFAULT_AUTHTOK
          ```

          ```
            # contents of the environment file
            SSSD_LDAP_DEFAULT_AUTHTOK=verysecretpassword
          ```
        '';
      };
    };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = lib.xor (cfg.settings != { }) (cfg.config != "");
          message = "services.sssd.settings and services.sssd.config are mutually exclusive";
        }
      ];

      # For `sssctl` to work.
      environment.etc."sssd/sssd.conf".source = settingsFile;
      environment.etc."sssd/conf.d".source = "${dataDir}/conf.d";

      systemd.services.sssd = {
        description = "System Security Services Daemon";
        wantedBy = [ "multi-user.target" ];
        before = [
          "systemd-user-sessions.service"
          "nss-user-lookup.target"
        ];
        after = [
          "network-online.target"
          "nscd.service"
        ];
        requires = [
          "network-online.target"
          "nscd.service"
        ];
        wants = [ "nss-user-lookup.target" ];
        restartTriggers = [
          config.environment.etc."nscd.conf".source
          settingsFileUnsubstituted
        ];
        environment.LDB_MODULES_PATH = "${pkgs.ldb}/modules/ldb:${pkgs.sssd}/modules/ldb";
        serviceConfig = {
          # systemd needs to start sssd directly for "NotifyAccess=main" to work
          ExecStart = "${pkgs.sssd}/bin/sssd -i -c ${settingsFile}";
          Type = "notify";
          NotifyAccess = "main";
          PIDFile = "/run/sssd.pid";
          CapabilityBoundingSet = [
            "CAP_IPC_LOCK"
            "CAP_CHOWN"
            "CAP_DAC_READ_SEARCH"
            "CAP_KILL"
            "CAP_NET_ADMIN"
            "CAP_SYS_NICE"
            "CAP_FOWNER"
            "CAP_SETGID"
            "CAP_SETUID"
            "CAP_SYS_ADMIN"
            "CAP_SYS_RESOURCE"
            "CAP_BLOCK_SUSPEND"
          ];
          Restart = "on-abnormal";
          StateDirectory = baseNameOf dataDir;
          # We cannot use LoadCredential here because it's not available in ExecStartPre
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        };
        unitConfig = {
          StartLimitIntervalSec = "50s";
          StartLimitBurst = 5;
        };
        preStart = ''
          mkdir -p "${dataDir}/conf.d"
          [ -f ${settingsFile} ] && rm -f ${settingsFile}
          old_umask=$(umask)
          umask 0177
          ${pkgs.envsubst}/bin/envsubst \
            -o ${settingsFile} \
            -i ${settingsFileUnsubstituted}
          umask $old_umask
          mkdir -p /var/lib/sss/{pubconf,db,mc,pipes,gpo_cache,secrets} /var/lib/sss/pipes/private /var/lib/sss/pubconf/krb5.include.d
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

    (lib.mkIf cfg.kcm {
      systemd.services.sssd-kcm = {
        description = "SSSD Kerberos Cache Manager";
        requires = [ "sssd-kcm.socket" ];
        serviceConfig = {
          ExecStartPre = "-${pkgs.sssd}/bin/sssd --genconf-section=kcm";
          ExecStart = "${pkgs.sssd}/libexec/sssd/sssd_kcm --uid 0 --gid 0";
          CapabilityBoundingSet = [
            "CAP_IPC_LOCK"
            "CAP_CHOWN"
            "CAP_DAC_READ_SEARCH"
            "CAP_FOWNER"
            "CAP_SETGID"
            "CAP_SETUID"
          ];
        };
        restartTriggers = [
          settingsFileUnsubstituted
        ];
      };
      systemd.sockets.sssd-kcm = {
        description = "SSSD Kerberos Cache Manager responder socket";
        wantedBy = [ "sockets.target" ];
        # Matches the default in MIT krb5 and Heimdal:
        # https://github.com/krb5/krb5/blob/krb5-1.19.3-final/src/include/kcm.h#L43
        listenStreams = [ "/var/run/.heim_org.h5l.kcm-socket" ];
      };
      security.krb5.settings.libdefaults.default_ccache_name = "KCM:";
    })

    (lib.mkIf cfg.sshAuthorizedKeysIntegration {
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
    })
  ];

  meta.maintainers = with lib.maintainers; [ bbigras ];
}
