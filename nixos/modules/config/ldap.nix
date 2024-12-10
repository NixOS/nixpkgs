{
  config,
  lib,
  pkgs,
  ...
}:

with pkgs;
with lib;

let

  cfg = config.users.ldap;

  # Careful: OpenLDAP seems to be very picky about the indentation of
  # this file.  Directives HAVE to start in the first column!
  ldapConfig = {
    target = "ldap.conf";
    source = writeText "ldap.conf" ''
      uri ${config.users.ldap.server}
      base ${config.users.ldap.base}
      timelimit ${toString config.users.ldap.timeLimit}
      bind_timelimit ${toString config.users.ldap.bind.timeLimit}
      bind_policy ${config.users.ldap.bind.policy}
      ${optionalString config.users.ldap.useTLS ''
        ssl start_tls
      ''}
      ${optionalString (config.users.ldap.bind.distinguishedName != "") ''
        binddn ${config.users.ldap.bind.distinguishedName}
      ''}
      ${optionalString (cfg.extraConfig != "") cfg.extraConfig}
    '';
  };

  nslcdConfig = writeText "nslcd.conf" ''
    uri ${cfg.server}
    base ${cfg.base}
    timelimit ${toString cfg.timeLimit}
    bind_timelimit ${toString cfg.bind.timeLimit}
    ${optionalString (cfg.bind.distinguishedName != "") "binddn ${cfg.bind.distinguishedName}"}
    ${optionalString (cfg.daemon.rootpwmoddn != "") "rootpwmoddn ${cfg.daemon.rootpwmoddn}"}
    ${optionalString (cfg.daemon.extraConfig != "") cfg.daemon.extraConfig}
  '';

  # nslcd normally reads configuration from /etc/nslcd.conf.
  # this file might contain secrets. We append those at runtime,
  # so redirect its location to something more temporary.
  nslcdWrapped = runCommand "nslcd-wrapped" { nativeBuildInputs = [ makeWrapper ]; } ''
    mkdir -p $out/bin
    makeWrapper ${nss_pam_ldapd}/sbin/nslcd $out/bin/nslcd \
      --set LD_PRELOAD    "${pkgs.libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS "/etc/nslcd.conf=/run/nslcd/nslcd.conf"
  '';

in

{

  ###### interface

  options = {

    users.ldap = {

      enable = mkEnableOption "authentication against an LDAP server";

      loginPam = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to include authentication against LDAP in login PAM.";
      };

      nsswitch = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to include lookup against LDAP in NSS.";
      };

      server = mkOption {
        type = types.str;
        example = "ldap://ldap.example.org/";
        description = "The URL of the LDAP server.";
      };

      base = mkOption {
        type = types.str;
        example = "dc=example,dc=org";
        description = "The distinguished name of the search base.";
      };

      useTLS = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, use TLS (encryption) over an LDAP (port 389)
          connection.  The alternative is to specify an LDAPS server (port
          636) in {option}`users.ldap.server` or to forego
          security.
        '';
      };

      timeLimit = mkOption {
        default = 0;
        type = types.int;
        description = ''
          Specifies the time limit (in seconds) to use when performing
          searches. A value of zero (0), which is the default, is to
          wait indefinitely for searches to be completed.
        '';
      };

      daemon = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to let the nslcd daemon (nss-pam-ldapd) handle the
            LDAP lookups for NSS and PAM. This can improve performance,
            and if you need to bind to the LDAP server with a password,
            it increases security, since only the nslcd user needs to
            have access to the bindpw file, not everyone that uses NSS
            and/or PAM. If this option is enabled, a local nscd user is
            created automatically, and the nslcd service is started
            automatically when the network get up.
          '';
        };

        extraConfig = mkOption {
          default = "";
          type = types.lines;
          description = ''
            Extra configuration options that will be added verbatim at
            the end of the nslcd configuration file (`nslcd.conf(5)`).
          '';
        };

        rootpwmoddn = mkOption {
          default = "";
          example = "cn=admin,dc=example,dc=com";
          type = types.str;
          description = ''
            The distinguished name to use to bind to the LDAP server
            when the root user tries to modify a user's password.
          '';
        };

        rootpwmodpwFile = mkOption {
          default = "";
          example = "/run/keys/nslcd.rootpwmodpw";
          type = types.str;
          description = ''
            The path to a file containing the credentials with which to bind to
            the LDAP server if the root user tries to change a user's password.
          '';
        };
      };

      bind = {
        distinguishedName = mkOption {
          default = "";
          example = "cn=admin,dc=example,dc=com";
          type = types.str;
          description = ''
            The distinguished name to bind to the LDAP server with. If this
            is not specified, an anonymous bind will be done.
          '';
        };

        passwordFile = mkOption {
          default = "/etc/ldap/bind.password";
          type = types.str;
          description = ''
            The path to a file containing the credentials to use when binding
            to the LDAP server (if not binding anonymously).
          '';
        };

        timeLimit = mkOption {
          default = 30;
          type = types.int;
          description = ''
            Specifies the time limit (in seconds) to use when connecting
            to the directory server. This is distinct from the time limit
            specified in {option}`users.ldap.timeLimit` and affects
            the initial server connection only.
          '';
        };

        policy = mkOption {
          default = "hard_open";
          type = types.enum [
            "hard_open"
            "hard_init"
            "soft"
          ];
          description = ''
            Specifies the policy to use for reconnecting to an unavailable
            LDAP server. The default is `hard_open`, which
            reconnects if opening the connection to the directory server
            failed. By contrast, `hard_init` reconnects if
            initializing the connection failed. Initializing may not
            actually contact the directory server, and it is possible that
            a malformed configuration file will trigger reconnection. If
            `soft` is specified, then
            `nss_ldap` will return immediately on server
            failure. All hard reconnect policies block with exponential
            backoff before retrying.
          '';
        };
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra configuration options that will be added verbatim at
          the end of the ldap configuration file (`ldap.conf(5)`).
          If {option}`users.ldap.daemon` is enabled, this
          configuration will not be used. In that case, use
          {option}`users.ldap.daemon.extraConfig` instead.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.etc = optionalAttrs (!cfg.daemon.enable) {
      "ldap.conf" = ldapConfig;
    };

    system.nssModules = mkIf cfg.nsswitch (
      singleton (if cfg.daemon.enable then nss_pam_ldapd else nss_ldap)
    );

    system.nssDatabases.group = optional cfg.nsswitch "ldap";
    system.nssDatabases.passwd = optional cfg.nsswitch "ldap";
    system.nssDatabases.shadow = optional cfg.nsswitch "ldap";

    users = mkIf cfg.daemon.enable {
      groups.nslcd = {
        gid = config.ids.gids.nslcd;
      };

      users.nslcd = {
        uid = config.ids.uids.nslcd;
        description = "nslcd user.";
        group = "nslcd";
      };
    };

    systemd.services = mkMerge [
      (mkIf (!cfg.daemon.enable) {
        ldap-password = {
          wantedBy = [ "sysinit.target" ];
          before = [
            "sysinit.target"
            "shutdown.target"
          ];
          conflicts = [ "shutdown.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          serviceConfig.RemainAfterExit = true;
          script = ''
            if test -f "${cfg.bind.passwordFile}" ; then
              umask 0077
              conf="$(mktemp)"
              printf 'bindpw %s\n' "$(cat ${cfg.bind.passwordFile})" |
              cat ${ldapConfig.source} - >"$conf"
              mv -fT "$conf" /etc/ldap.conf
            fi
          '';
        };
      })

      (mkIf cfg.daemon.enable {
        nslcd = {
          wantedBy = [ "multi-user.target" ];

          preStart = ''
            umask 0077
            conf="$(mktemp)"
            {
              cat ${nslcdConfig}
              test -z '${cfg.bind.distinguishedName}' -o ! -f '${cfg.bind.passwordFile}' ||
              printf 'bindpw %s\n' "$(cat '${cfg.bind.passwordFile}')"
              test -z '${cfg.daemon.rootpwmoddn}' -o ! -f '${cfg.daemon.rootpwmodpwFile}' ||
              printf 'rootpwmodpw %s\n' "$(cat '${cfg.daemon.rootpwmodpwFile}')"
            } >"$conf"
            mv -fT "$conf" /run/nslcd/nslcd.conf
          '';

          restartTriggers = [
            nslcdConfig
            cfg.bind.passwordFile
            cfg.daemon.rootpwmodpwFile
          ];

          serviceConfig = {
            ExecStart = "${nslcdWrapped}/bin/nslcd";
            Type = "forking";
            Restart = "always";
            User = "nslcd";
            Group = "nslcd";
            RuntimeDirectory = [ "nslcd" ];
            PIDFile = "/run/nslcd/nslcd.pid";
            AmbientCapabilities = "CAP_SYS_RESOURCE";
          };
        };
      })
    ];

  };

  imports = [
    (mkRenamedOptionModule
      [ "users" "ldap" "bind" "password" ]
      [ "users" "ldap" "bind" "passwordFile" ]
    )
  ];
}
