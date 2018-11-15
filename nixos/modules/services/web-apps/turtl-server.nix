{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.turtl-server;

  turtlServerConfYAML = pkgs.writeTextFile {
    name = "turtl-server-config.yaml";
    text = ''
      ---
    '' + lib.optionalString (cfg.listenAddress != null) ''
      server:
        host: ${cfg.listenAddress}
        port: ${toString cfg.listenPort}
    '' + lib.optionalString (cfg.listenAddress == null) ''
      server:
        host:
        port: ${toString cfg.listenPort}
    '' + ''
      db:
        connstr: "postgres://${cfg.localDatabaseUser}:${cfg.localDatabasePassword}@localhost:5432/${cfg.localDatabaseName}"
        pool: 24

      loglevel: 'debug'

      app:
        enable_bookmarker_proxy: false
        api_url: ${cfg.apiUrl}
        www_url: ${cfg.wwwUrl}
        emails:
          admin: ${cfg.email.admin}
          info: ${cfg.email.info}
          invites: ${cfg.email.invites}
        secure_hash_salt: ${cfg.secureHashSalt}
        allow_unconfirmed_invites: false

      sync:
        max_bulk_sync_records: 32

      plugins:
        plugin_location: ${cfg.plugin.location}
        analytics:
          enabled: ${toString cfg.plugin.analytics}
        email:
          enabled: ${toString cfg.plugin.email}
        sync:
          enabled: ${toString cfg.plugin.sync}

    '' + lib.optionalString (cfg.uploads.local != null) ''
      uploads:
        local: ${cfg.uploads.local}
    '' + lib.optionalString (cfg.listenAddress == null) ''
      uploads:
        local: false
    '' + ''
        local_proxy: ${toString cfg.uploads.localProxy}
        url: ${cfg.uploads.url}

      s3:
        token: ${cfg.s3.token}
        secret: ${cfg.s3.secret}
        bucket: ${cfg.s3.bucket}
        endpoint: ${cfg.s3.endpoint}
      '';
  };

  # This is dirty, but turtl-server only takes relative paths
  turtlConfFileRelativePath = "../../../..${cfg.statePath}/config/config.yaml";
in

{
  options = {
    services.turtl-server = {
      enable = mkEnableOption "Turtl notebook server";

      statePath = mkOption {
        type = types.str;
        default = "/var/lib/turtl-server";
        description = "Turtl working directory";
      };

      apiUrl = mkOption {
        type = types.str;
        example = "https://api.yourdomain.com:8181";
        description = ''
          URL and port this Turtl-server instance is reachable under, without trailing slash.
        '';
      };

      wwwUrl = mkOption {
        type = types.str;
        example = "https://yourdomain.com";
        description = ''
          URL for the frontend service
        '';
      };

      listenAddress = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "127.0.0.1";
        description = ''
          Address this Turtl-server instance listens to. Defaults to all.
        '';
      };

      listenPort = mkOption {
        type = types.int;
        default = 8181;
        example = 8181;
        description = ''
          Port.
        '';
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = { };
        description = ''
          Addtional configuration options as Nix attribute set in config.json schema.
        '';
      };

      localDatabaseCreate = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Create a local PostgreSQL database for Turtl-server automatically.
        '';
      };

      localDatabaseName = mkOption {
        type = types.str;
        default = "turtl";
        description = ''
          Local Turtl-server database name.
        '';
      };

      localDatabaseUser = mkOption {
        type = types.str;
        default = "turtl";
        description = ''
          Local Turtl-server database username.
        '';
      };

      localDatabasePassword = mkOption {
        type = types.str;
        default = "tspgsecret";
        description = ''
          Password for local Turtl-server database user.
        '';
      };

      secureHashSalt= mkOption {
        type = types.str;
        default = "Plaque is a figment of the liberal media and the dental industry to scare you into buying useless appliances and pastes. Now, I've read the arguments on both sides and I haven't found any evidence yet to support the need to brush your teeth. Ever.";
        description = ''
          Replace this with a long, unique value. seriously. Write down a dream you had, or the short story you came up with during your creative writing class in your freshmen year of college. Have fun with it.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "turtl";
        description = ''
          User which runs the Turtl-server service.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "turtl";
        description = ''
          Group which runs the Turtl-server service.
        '';
      };

      email = {
        admin = mkOption {
          type = types.str;
          default = "admin@turtlapp.com";
          example = "admin@turtlapp.com";
          description = ''
            Admin email.
          '';
        };

        info = mkOption {
          type = types.str;
          default = "info@turtlapp.com";
          example = "info@turtlapp.com";
          description = ''
            Info email.
          '';
        };

        invites = mkOption {
          type = types.str;
          default = "invites@turtlapp.com";
          example = "invites@turtlapp.com";
          description = ''
            Invites email.
          '';
        };
      };

      plugin = {
        location = mkOption {
          type = types.str;
          default = "/var/www/turtl/server/plugins";
          example = "/var/www/turtl/server/plugins";
          description = ''
            Path where the plugins are installed.
          '';
        };

        analytics= mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable analytics plugin.
          '';
        };

        email= mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable email plugin.
          '';
        };

        sync= mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable sync plugin.
          '';
        };
      };

      uploads = {
        local = mkOption {
          type = types.nullOr types.str;
          default = "/var/www/turtl/server/public/uploads";
          example = "/var/www/turtl/server/public/uploads";
          description = ''
            If set to a path, files will be uploaded to the local filesystem instead of S3. otherwise, set to null.
          '';
        };

        localProxy= mkOption {
          type = types.bool;
          default = true;
          description = ''
            If true, downloading local files will be proxied through the turtl server.  This avoids needing to set up any CORS config in your favorite webserver, but may slightly affect performance on high-demand servers.
          '';
        };

        url = mkOption {
          type = types.str;
          default = "http://api.turtl.dev/uploads";
          example = "http://api.turtl.dev/uploads";
          description = ''
            If local_proxy is false, this is should be the url path the uploaded files are publicly available on.
          '';
        };
      };

      s3 = {
        token = mkOption {
          type = types.str;
          default = "IHADAPETSNAKEBUTHEDIEDNOOOOO";
          description = ''
            S3 token.
          '';
        };

        secret = mkOption {
          type = types.str;
          default = "";
          description = ''
            S3 secret.
          '';
        };

        bucket = mkOption {
          type = types.str;
          default = "";
          description = ''
            S3 bucket.
          '';
        };

        endpoint = mkOption {
          type = types.str;
          default = "https://s3.amazonaws.com";
          description = ''
            S3 endpoint.
          '';
        };
      };

    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      users.users = optionalAttrs (cfg.user == "turtl") (singleton {
        name = "turtl";
        group = cfg.group;
        uid = config.ids.uids.turtl;
        home = cfg.statePath;
      });

      users.groups = optionalAttrs (cfg.group == "turtl") (singleton {
        name = "turtl";
        gid = config.ids.gids.turtl;
      });

      services.postgresql.enable = cfg.localDatabaseCreate;

      # The systemd service will fail to execute the preStart hook
      # if the WorkingDirectory does not exist
      system.activationScripts.turtl-server = ''
        mkdir -p ${cfg.statePath}
      '';

      systemd.services.turtl-server = {
        description = "Turtl-server notebook service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "postgresql.service" ];

        preStart = ''
	  export TURTL_CONFIG_FILE=${turtlConfFileRelativePath} 
	  export TURTL_SERVER_PLUGIN_REPO=""
	  export TURTL_SERVER_PLUGIN_LOCATION="${cfg.plugin.location}"
          mkdir -p ${cfg.statePath}/{config,logs}
          mkdir -p ${cfg.plugin.location} ${cfg.uploads.local}
          ln -sf ${pkgs.turtl-server}/{bin,scripts} ${cfg.statePath}
          if ! test -e "${cfg.statePath}/config/.initial-created"; then
            rm -f ${cfg.statePath}/config/config.yaml
            cp ${turtlServerConfYAML} ${cfg.statePath}/config/config.yaml
            touch ${cfg.statePath}/config/.initial-created
          fi
        '' + lib.optionalString cfg.localDatabaseCreate ''
          if ! test -e "${cfg.statePath}/.db-created"; then
            ${pkgs.sudo}/bin/sudo -u ${config.services.postgresql.superUser} \
              ${config.services.postgresql.package}/bin/psql postgres -c \
                "CREATE ROLE ${cfg.localDatabaseUser} WITH LOGIN NOCREATEDB NOCREATEROLE ENCRYPTED PASSWORD '${cfg.localDatabasePassword}'"
            ${pkgs.sudo}/bin/sudo -u ${config.services.postgresql.superUser} \
              ${config.services.postgresql.package}/bin/createdb \
                --owner ${cfg.localDatabaseUser} ${cfg.localDatabaseName}
            ${cfg.statePath}/scripts/init-db.sh
            touch ${cfg.statePath}/.db-created
          fi
        '' + ''
          chown ${cfg.user}:${cfg.group} -R ${cfg.statePath} ${cfg.plugin.location} ${cfg.uploads.local}
          chmod u+rw,g+r,o-rwx -R ${cfg.statePath} ${cfg.plugin.location} ${cfg.uploads.local}
          ${pkgs.turtl-server}/scripts/install-plugins.sh
        '';

        serviceConfig = {
          PermissionsStartOnly = true;
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${cfg.statePath}/bin/turtl-server";
          WorkingDirectory = "${cfg.statePath}";
          Restart = "always";
          RestartSec = "10";
          LimitNOFILE = "49152";
        };
	environment = {
	  TURTL_CONFIG_FILE = turtlConfFileRelativePath;
	};
        unitConfig.JoinsNamespaceOf = mkIf cfg.localDatabaseCreate "postgresql.service";
      };
    })
  ];
}

