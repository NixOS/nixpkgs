{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf optionalString stringAfter;

  options = {
    users = {
      ldap = {

        enable = mkOption {
          default = false;
          description = "
            Whether to enable authentication against an LDAP server.
          ";
        };

        server = mkOption {
          example = "ldap://ldap.example.org/";
          description = "
            The URL of the LDAP server.
          ";
        };

        base = mkOption {
          example = "dc=example,dc=org";
          description = "
            The distinguished name of the search base.
          ";
        };

        useTLS = mkOption {
          default = false;
          description = "
            If enabled, use TLS (encryption) over an LDAP (port 389)
            connection.  The alternative is to specify an LDAPS server (port
            636) in <option>users.ldap.server</option> or to forego
            security.
          ";
        };

        timeLimit = mkOption {
          default = 0;
          type = with pkgs.lib.types; int;
          description = "
            Specifies the time limit (in seconds) to use when performing
            searches. A value of zero (0), which is the default, is to
            wait indefinitely for searches to be completed.
          ";
        };

        bind = {
          distinguishedName = mkOption {
            default = "";
            example = "cn=admin,dc=example,dc=com";
            type = with pkgs.lib.types; string;
            description = "
              The distinguished name to bind to the LDAP server with. If this
              is not specified, an anonymous bind will be done.
            ";
          };

          password = mkOption {
            default = "/etc/ldap/bind.password";
            type = with pkgs.lib.types; string;
            description = "
              The path to a file containing the credentials to use when binding
              to the LDAP server (if not binding anonymously).
            ";
          };

          timeLimit = mkOption {
            default = 30;
            type = with pkgs.lib.types; int;
            description = "
              Specifies the time limit (in seconds) to use when connecting
              to the directory server. This is distinct from the time limit
              specified in <literal>users.ldap.timeLimit</literal> and affects
              the initial server connection only.
            ";
          };

          policy = mkOption {
            default = "hard_open";
            type = with pkgs.lib.types; string;
            description = "
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
            ";
          };
        };

      };
    };
  };
in

###### implementation

mkIf config.users.ldap.enable {
  require = [
    options
  ];

  # LDAP configuration.
  environment = {
    etc = [

      # Careful: OpenLDAP seems to be very picky about the indentation of
      # this file.  Directives HAVE to start in the first column!
      { source = pkgs.writeText "ldap.conf"
          ''
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
          '';
        target = "ldap.conf";
      }

    ];
  };

  system.activationScripts.ldap = stringAfter [ "etc" ] (
    optionalString (config.users.ldap.bind.distinguishedName != "") ''
      if test -f "${config.users.ldap.bind.password}" ; then
        echo "bindpw $(cat ${config.users.ldap.bind.password})" | cat /etc/ldap.conf - > /etc/ldap.conf.bindpw
        mv -fT /etc/ldap.conf.bindpw /etc/ldap.conf
        chmod 600 /etc/ldap.conf
      fi
    ''
  );

}
