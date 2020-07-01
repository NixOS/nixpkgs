{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.firefox.syncserver;

  defaultDbLocation = "/var/db/firefox-sync-server/firefox-sync-server.db";
  defaultSqlUri = "sqlite:///${defaultDbLocation}";

  syncServerIni = pkgs.writeText "syncserver.ini" ''
    [DEFAULT]
    overrides = ${cfg.privateConfig}

    [server:main]
    use = egg:gunicorn
    host = ${cfg.listen.address}
    port = ${toString cfg.listen.port}

    [app:main]
    use = egg:syncserver

    [syncserver]
    public_url = ${cfg.publicUrl}
    ${optionalString (cfg.sqlUri != "") "sqluri = ${cfg.sqlUri}"}
    allow_new_users = ${boolToString cfg.allowNewUsers}

    [browserid]
    backend = tokenserver.verifiers.LocalVerifier
    audiences = ${removeSuffix "/" cfg.publicUrl}
  '';

  user = "syncserver";
  group = "syncserver";
in

{
  meta.maintainers = with lib.maintainers; [ nadrieril ];

  options = {
    services.firefox.syncserver = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable a Firefox Sync Server, this give the opportunity to
          Firefox users to store all synchronized data on their own server. To use this
          server, Firefox users should visit the <option>about:config</option>, and
          replicate the following change

          <screen>
          services.sync.tokenServerURI: http://localhost:5000/token/1.0/sync/1.5
          </screen>

          where <option>http://localhost:5000/</option> corresponds to the
          public url of the server.
        '';
      };

      listen.address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = ''
          Address on which the sync server listen to.
        '';
      };

      listen.port = mkOption {
        type = types.int;
        default = 5000;
        description = ''
          Port on which the sync server listen to.
        '';
      };

      publicUrl = mkOption {
        type = types.str;
        default = "http://localhost:5000/";
        example = "http://sync.example.com/";
        description = ''
          Public URL with which firefox users can use to access the sync server.
        '';
      };

      allowNewUsers = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to allow new-user signups on the server. Only request by
          existing accounts will be honored.
        '';
      };

      sqlUri = mkOption {
        type = types.str;
        default = defaultSqlUri;
        example = "postgresql://scott:tiger@localhost/test";
        description = ''
          The location of the database. This URL is composed of
          <option>dialect[+driver]://user:password@host/dbname[?key=value..]</option>,
          where <option>dialect</option> is a database name such as
          <option>mysql</option>, <option>oracle</option>, <option>postgresql</option>,
          etc., and <option>driver</option> the name of a DBAPI, such as
          <option>psycopg2</option>, <option>pyodbc</option>, <option>cx_oracle</option>,
          etc. The <link
          xlink:href="http://docs.sqlalchemy.org/en/rel_0_9/core/engines.html#database-urls">
          SQLAlchemy documentation</link> provides more examples and describe the syntax of
          the expected URL.
        '';
      };

      privateConfig = mkOption {
        type = types.str;
        default = "/etc/firefox/syncserver-secret.ini";
        description = ''
          The private config file is used to extend the generated config with confidential
          information, such as the <option>syncserver.sqlUri</option> setting if it contains a
          password, and the <option>syncserver.secret</option> setting is used by the server to
          generate cryptographically-signed authentication tokens.

          If this file does not exists, then it is created with a generated
          <option>syncserver.secret</option> settings.
       '';
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.syncserver = {
      after = [ "network.target" ];
      description = "Firefox Sync Server";
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.coreutils
        (pkgs.python.withPackages (ps: [ pkgs.syncserver ps.gunicorn ]))
      ];

      serviceConfig = {
        User = user;
        Group = group;
        PermissionsStartOnly = true;
      };

      preStart = ''
        if ! test -e ${cfg.privateConfig}; then
          mkdir -p $(dirname ${cfg.privateConfig})
          echo  > ${cfg.privateConfig} '[syncserver]'
          chmod 600 ${cfg.privateConfig}
          echo >> ${cfg.privateConfig} "secret = $(head -c 20 /dev/urandom | sha1sum | tr -d ' -')"
        fi
        chmod 600 ${cfg.privateConfig}
        chmod 755 $(dirname ${cfg.privateConfig})
        chown ${user}:${group} ${cfg.privateConfig}

      '' + optionalString (cfg.sqlUri == defaultSqlUri) ''
        if ! test -e $(dirname ${defaultDbLocation}); then
          mkdir -m 700 -p $(dirname ${defaultDbLocation})
          chown ${user}:${group} $(dirname ${defaultDbLocation})
        fi

        # Move previous database file if it exists
        oldDb="/var/db/firefox-sync-server.db"
        if test -f $oldDb; then
          mv $oldDb ${defaultDbLocation}
          chown ${user}:${group} ${defaultDbLocation}
        fi
      '';

      script = ''
        gunicorn --paste ${syncServerIni}
      '';
    };

    users.users.${user} = {
      inherit group;
      isSystemUser = true;
    };

    users.groups.${group} = {};
  };
}
