{ config, lib, pkgs, ... }:

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
        tls_checkpeer no
      ''}
      ${optionalString (config.users.ldap.bind.distinguishedName != "") ''
        binddn ${config.users.ldap.bind.distinguishedName}
      ''}
      ${optionalString (cfg.extraConfig != "") cfg.extraConfig }
    '';
  };

  nslcdConfig = {
    target = "nslcd.conf";
    source = writeText "nslcd.conf" ''
      uid nslcd
      gid nslcd
      uri ${cfg.server}
      base ${cfg.base}
      timelimit ${toString cfg.timeLimit}
      bind_timelimit ${toString cfg.bind.timeLimit}
      ${optionalString (cfg.bind.distinguishedName != "")
        "binddn ${cfg.bind.distinguishedName}" }
      ${optionalString (cfg.daemon.extraConfig != "") cfg.daemon.extraConfig }
    '';
  };

  insertLdapPassword = !config.users.ldap.daemon.enable &&
    config.users.ldap.bind.distinguishedName != "";

in

{

  ###### interface

  options = {

    users.ldap = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable authentication against an LDAP server.";
      };

      loginPam = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to include authentication against LDAP in login PAM";
      };

      nsswitch = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to include lookup against LDAP in NSS";
      };

      server = mkOption {
        example = "ldap://ldap.example.org/";
        description = "The URL of the LDAP server.";
      };

      base = mkOption {
        example = "dc=example,dc=org";
        description = "The distinguished name of the search base.";
      };

      useTLS = mkOption {
        default = false;
        description = ''
          If enabled, use TLS (encryption) over an LDAP (port 389)
          connection.  The alternative is to specify an LDAPS server (port
          636) in <option>users.ldap.server</option> or to forego
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
          default =  "";
          type = types.lines;
          description = ''
            Extra configuration options that will be added verbatim at
            the end of the nslcd configuration file (nslcd.conf).
          '' ;
        } ;
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

        password = mkOption {
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
            specified in <literal>users.ldap.timeLimit</literal> and affects
            the initial server connection only.
          '';
        };

        policy = mkOption {
          default = "hard_open";
          type = types.enum [ "hard_open" "hard_init" "soft" ];
          description = ''
            Specifies the policy to use for reconnecting to an unavailable
            LDAP server. The default is <literal>hard_open</literal>, which
            reconnects if opening the connection to the directory server
            failed. By contrast, <literal>hard_init</literal> reconnects if
            initializing the connection failed. Initializing may not
            actually contact the directory server, and it is possible that
            a malformed configuration file will trigger reconnection. If
            <literal>soft</literal> is specified, then
            <literal>nss_ldap</literal> will return immediately on server
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
          the end of the ldap configuration file (ldap.conf).
          If <literal>users.ldap.daemon</literal> is enabled, this
          configuration will not be used. In that case, use
          <literal>users.ldap.daemon.extraConfig</literal> instead.
        '' ;
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.etc = if cfg.daemon.enable then [nslcdConfig] else [ldapConfig];

    system.activationScripts = mkIf insertLdapPassword {
      ldap = stringAfter [ "etc" "groups" "users" ] ''
        if test -f "${cfg.bind.password}" ; then
          echo "bindpw "$(cat ${cfg.bind.password})"" | cat ${ldapConfig.source} - > /etc/ldap.conf.bindpw
          mv -fT /etc/ldap.conf.bindpw /etc/ldap.conf
          chmod 600 /etc/ldap.conf
        fi
      '';
    };

    system.nssModules = singleton (
      if cfg.daemon.enable then nss_pam_ldapd else nss_ldap
    );

    users = mkIf cfg.daemon.enable {
      extraGroups.nslcd = {
        gid = config.ids.gids.nslcd;
      };

      extraUsers.nslcd = {
        uid = config.ids.uids.nslcd;
        description = "nslcd user.";
        group = "nslcd";
      };
    };

    systemd.services = mkIf cfg.daemon.enable {

      nslcd = {
        wantedBy = [ "multi-user.target" ];

        preStart = ''
          mkdir -p /run/nslcd
          rm -f /run/nslcd/nslcd.pid;
          chown nslcd.nslcd /run/nslcd
          ${optionalString (cfg.bind.distinguishedName != "") ''
            if test -s "${cfg.bind.password}" ; then
              ln -sfT "${cfg.bind.password}" /run/nslcd/bindpw
            fi
          ''}
        '';

        serviceConfig = {
          ExecStart = "${nss_pam_ldapd}/sbin/nslcd";
          Type = "forking";
          PIDFile = "/run/nslcd/nslcd.pid";
          Restart = "always";
        };
      };

    };

  };
}
