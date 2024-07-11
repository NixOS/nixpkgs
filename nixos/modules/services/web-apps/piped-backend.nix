{
  lib,
  config,
  pkgs,
  ...
}:
let
  this = config.services.piped.backend;
  https =
    domain: if lib.hasSuffix ".localhost" domain then "http://${domain}" else "https://${domain}";
in
{
  options.services.piped.backend = {
    enable = lib.mkEnableOption "Piped Backend";

    package = lib.mkPackageOption pkgs "piped-backend" { };

    port = lib.mkOption {
      type = lib.types.port;
      example = 8000;
      default = 28769;
      description = ''
        The port Piped Backend should listen on.

        To allow access from outside,
        you can use either {option}`services.piped.backend.nginx`
        or add `config.services.piped.backend.port` to {option}`networking.firewall.allowedTCPPorts`.
      '';
    };

    settings = lib.mkOption {
      # Not actually used for file generation but for setting constraints on the values
      inherit (pkgs.formats.javaProperties { }) type;
      description = ''
        The settings Piped Backend should use.

        See [config.properties](https://github.com/TeamPiped/Piped-Backend/blob/master/config.properties) for a list of all possible options.
      '';
    };

    externalUrl = lib.mkOption {
      type = lib.types.str;
      example = "https://pipedapi.example.com";
      default = https this.nginx.domain;
      defaultText = "The {option}`nginx.domain`";
      description = ''
        The external URL of Piped Backend.
      '';
    };

    nginx = {
      enable = lib.mkEnableOption "nginx as a reverse proxy for Piped Backend";

      domain = lib.mkOption {
        type = lib.types.str;
        default = "pipedapi.localhost";
        description = ''
          The domain Piped Backend is reachable on.
        '';
      };

      pubsubExtraConfig = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "allow all;";
        description = ''
          Nginx extra config for the `/webhooks/pubsub` route.
        '';
      };
    };

    database = {
      createLocally =
        lib.mkEnableOption "create a local database with PostgreSQL"
        // lib.mkOption { default = true; };
      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          The database host Piped should use.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = config.services.postgresql.settings.port;
        defaultText = lib.literalExpression "config.services.postgresql.settings.port";
        description = ''
          The database port Piped should use.

          Defaults to the the default postgresql port.
        '';
      };

      database = lib.mkOption {
        type = lib.types.str;
        default = "piped-backend";
        description = ''
          The database Piped should use.
        '';
      };

      username = lib.mkOption {
        type = lib.types.str;
        default = "piped-backend";
        description = ''
          The database username Piped should use.
        '';
      };

      passwordFile = lib.mkOption {
        type = lib.types.path;
        example = "/run/keys/db_password";
        default = throw "You must specify a `passwordFile`.";
        description = ''
          Path to file containing the database password.
        '';
      };
    };
  };

  config = lib.mkIf this.enable {
    services.piped.backend = {
      settings = {
        PORT = toString this.port;
        API_URL = this.externalUrl;
      };
    };

    services.postgresql = lib.mkIf this.database.createLocally {
      enable = true;
      enableTCPIP = true; # Java can't talk postgres via UNIX sockets...
      ensureDatabases = [ "piped-backend" ];
      ensureUsers = [
        {
          name = "piped-backend";
          ensureDBOwnership = true;
          inherit (this.database) passwordFile;
        }
      ];
    };

    systemd.services.piped-backend =
      let
        databaseServices = lib.mkIf this.database.createLocally [ "postgresql.service" ];
      in
      {
        after = databaseServices;
        bindsTo = databaseServices;
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "piped-backend";
          Group = "piped-backend";
          DynamicUser = true;
          RuntimeDirectory = "piped-backend";
          WorkingDirectory = "%t/piped-backend"; # %t is the RuntimeDirectory root
          LoadCredential = [ "databasePassword:${this.database.passwordFile}" ];
        };
        environment = this.settings;
        # We can't pass the DB connection password directly and must therefore
        # put it into a transient config file instead. The WokringDirectory is
        # under the RuntimeDirectory which itself is in RAM and dies with the
        # service. This isn't optimal as credentials cann still be evicted into
        # swap but the service itself does not make any effort to secure the
        # password either.
        preStart = ''
          cat << EOF > config.properties
          hibernate.connection.url: jdbc:postgresql://${this.database.host}:${toString this.database.port}/${this.database.database}
          hibernate.connection.driver_class: org.postgresql.Driver
          hibernate.dialect: org.hibernate.dialect.PostgreSQLDialect
          hibernate.connection.username: ${this.database.username}
          hibernate.connection.password: $(cat $CREDENTIALS_DIRECTORY/databasePassword)
          EOF
        '';
        script = ''
          ${this.package}/bin/piped-backend
        '';
      };

    services.nginx = lib.mkIf this.nginx.enable {
      enable = true;
      appendHttpConfig = ''
        proxy_cache_path /tmp/pipedapi_cache levels=1:2 keys_zone=pipedapi:4m max_size=2g inactive=60m use_temp_path=off;
      '';
      virtualHosts.${this.nginx.domain} = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString this.port}";
          extraConfig = ''
            proxy_cache pipedapi;
          '';
        };
        locations."/webhooks/pubsub" = {
          proxyPass = "http://127.0.0.1:${toString this.port}";
          extraConfig = ''
            proxy_cache pipedapi;
            ${this.nginx.pubsubExtraConfig}
          '';
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    defelo
    atemu
  ];
}
