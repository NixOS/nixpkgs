{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let

  cfg = config.users.ldap;

  # Generate a list of shell commands which emit config directives for the
  # given secret. If `key` is set, then there should be a corresponding secret
  # in `file`, which should be included in the config file as the value of the
  # `option` setting. Otherwise this secret is not necessary, so this function
  # returns an empty list.
  secretFileFor = key: option: file: optional (key != "") ''
    test -s ${escapeShellArg file} && echo "${option} $(cat ${escapeShellArg file})"
  '';

  commonConfig = ''
    uri ${cfg.server}
    base ${cfg.base}
    timelimit ${toString cfg.timeLimit}
    bind_timelimit ${toString cfg.bind.timeLimit}
    ${optionalString (cfg.bind.distinguishedName != "")
      "binddn ${cfg.bind.distinguishedName}"}
  '';

  commonSecrets = secretFileFor cfg.bind.distinguishedName "bindpw" cfg.bind.passwordFile;

  # Careful: OpenLDAP seems to be very picky about the indentation of
  # this file.  Directives HAVE to start in the first column!
  ldapConfig = {
    target = "ldap.conf";
    text = ''
      bind_policy ${cfg.bind.policy}
      ${optionalString cfg.useTLS "ssl start_tls"}
      ${commonConfig}
      ${cfg.extraConfig}
    '';
    secrets = commonSecrets;
    secretPath = "/run/nscd/ldap.conf";
    secretOwner = "nscd";
  };

  nslcdConfig = {
    target = "nslcd.conf";
    text = ''
      uid nslcd
      gid nslcd
      ${optionalString (cfg.daemon.rootpwmoddn != "")
        "rootpwmoddn ${cfg.daemon.rootpwmoddn}"}
      ${commonConfig}
      ${cfg.daemon.extraConfig}
    '';
    secrets = commonSecrets ++
      secretFileFor cfg.daemon.rootpwmoddn "rootpwmodpw" cfg.daemon.rootpwmodpwFile;
    secretPath = "/run/nslcd/nslcd.conf";
    secretOwner = "nslcd";
  };

  # Set up a symlink in /etc to the right configuration file. If the config has
  # no use for secrets, then it will be a symlink to a file in the Nix store;
  # otherwise it's a symlink to a file which mkConfigScript is responsible for
  # creating.
  mkEtc = thisConfig: { ${thisConfig.target} =
    if thisConfig.secrets == []
    then { inherit (thisConfig) text; }
    else {
      source = thisConfig.secretPath;
      mode = "direct-symlink";
    };
  };

  # Construct a list of commands, suitable for serviceConfig.ExecStartPre,
  # which will arrange that thisConfig.target includes any secrets it needs. If
  # the config has no use for secrets, this will be an empty list. Otherwise
  # the returned command will start with "!", which tells systemd to run this
  # command as root even if the service is configured to run as a different
  # user.
  mkConfigScript = thisConfig: optional (thisConfig.secrets != []) "!${
    let baseconf = writeText (baseNameOf thisConfig.target) thisConfig.text;
    in writeScript "${baseNameOf thisConfig.target}-append-secrets" ''
      #!${pkgs.runtimeShell} -e
      umask 0377
      secrets=$(mktemp ${escapeShellArg thisConfig.secretPath}.XXXXXXXXXX)
      {
        ${concatStringsSep "  " thisConfig.secrets}
      } > "$secrets"
      if test -s "$secrets"; then
        cat ${baseconf} >> "$secrets"
        mv -fT "$secrets" ${escapeShellArg thisConfig.secretPath}
        chown ${thisConfig.secretOwner} ${escapeShellArg thisConfig.secretPath}
      else
        rm -f "$secrets"
        ln -sfn ${baseconf} ${escapeShellArg thisConfig.secretPath}
      fi
    ''
  }";

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

  config = mkIf cfg.enable (mkMerge [
  {
    assertions = [{
      assertion = config.services.nscd.enable;
      message = ''
        `users.ldap.enable = true` requires `services.nscd.enable = true`
        (otherwise most programs won't be able to find the LDAP NSS module)
      '';
    }];
  }

  (mkIf (!cfg.daemon.enable) {
    system.nssModules = [ nss_ldap ];
    environment.etc = mkEtc ldapConfig;
    systemd.services.nscd.serviceConfig.ExecStartPre = mkConfigScript ldapConfig;
  })

  (mkIf cfg.daemon.enable {
    system.nssModules = [ nss_pam_ldapd ];

    users = {
      groups.nslcd = {
        gid = config.ids.gids.nslcd;
      };

      users.nslcd = {
        uid = config.ids.uids.nslcd;
        description = "nslcd user.";
        group = "nslcd";
      };
    };

    environment.etc = mkEtc nslcdConfig;
    systemd.services = {
      nslcd = {
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStartPre = mkConfigScript nslcdConfig;
          ExecStart = "${nss_pam_ldapd}/sbin/nslcd";
          Type = "forking";
          Restart = "always";
          User = "nslcd";
          Group = "nslcd";
          RuntimeDirectory = [ "nslcd" ];
          PIDFile = "/run/nslcd/nslcd.pid";
        };
      };

    };
  })

  ]);

  imports =
    [ (mkRenamedOptionModule [ "users" "ldap" "bind" "password"] [ "users" "ldap" "bind" "passwordFile"])
    ];
}
