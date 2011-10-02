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
