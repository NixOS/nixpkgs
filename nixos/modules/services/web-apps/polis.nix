{ lib, config, pkgs, ... }:
let
  databaseName = "polis";
  databaseUser = databaseName;
  staticFilesPort = "8080";
in
{

  options.services.polis = {
    enable = lib.mkEnableOption "polis";

    nginx = {
      enable = lib.mkEnableOption "nginx";
      hostname = lib.mkOption {
        type = lib.types.str;
        description = ''
          The virtual hostname where polis is accessible
        '';
      };
      openPorts = lib.mkOption {
        description = ''
          Whether to open ports 80 and 443.
        '';
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf config.services.polis.enable {

    services.postgresql.enable = true;
    services.postgresql.ensureDatabases = [ databaseName ];
    services.postgresql.ensureUsers = [
      {
        name = databaseUser;
        ensureDBOwnership = true;
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf config.services.polis.nginx.openPorts [
      80
      443
    ];

    services.nginx = lib.mkIf config.services.polis.nginx.enable {
      enable = true;
      virtualHosts.${config.services.polis.nginx.hostname} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:5000";
        };
      };
    };

    users = {
      users.polis.isSystemUser = true;
      users.polis.group = "polis";
      groups.polis = {};
    };

    systemd.services.polis-db-init = {
      description = "polis-db-init";
      after = [ "postgresql.service" ];
      wants = [ "postgresql.service" ];
      serviceConfig = {
        Type = "oneshot";
        StateDirectory = "polis-db-init";
        # Only readable by root, stores the database password
        StateDirectoryMode = "700";
      };
      path = [
        config.services.postgresql.package
        pkgs.sudo
      ];
      script = ''
        if [[ ! -e "$STATE_DIRECTORY"/first-time ]]; then

          set -x
          for file in ${pkgs.polis}/share/polis/migrations/*; do
            sudo -u polis psql -f "$file"
          done

          touch "$STATE_DIRECTORY"/first-time

          password=$(${pkgs.pwgen}/bin/pwgen 32 1)

          # clojure's postgres library doesn't support unix sockets: https://korma.github.io/Korma/korma.db.html#var-postgres
          sudo -u postgres psql <<< "ALTER ROLE ${databaseUser} LOGIN PASSWORD '$password'"

          # SSL shouldn't be used: https://github.com/compdemocracy/polis/blob/0500fec09e1607f731c3544511622910a35028ed/math/src/polismath/components/postgres.clj#L35
          # but for some reason the sslmode=disable is still needed, probably related to root certs missing (adding cacert somehow might be an alternative fix)
          # Also the port is needed, bad error if it's not there
          echo "DATABASE_URL=postgres://${databaseUser}:$password@127.0.0.1:${toString config.services.postgresql.settings.port}/${databaseName}?sslmode=disable" > "$STATE_DIRECTORY"/env
        fi
      '';
    };

    systemd.services.polis-file-server = {
      description = "polis-file-server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        PORT = staticFilesPort;
        EMBED_SERVICE_HOSTNAME = config.services.polis.nginx.hostname;
        NODE_ENV = "production";
      };

      serviceConfig = {
        Type = "simple";
        User = "polis";
        Group = "polis";
        ExecStart = "${pkgs.polis}/bin/polis-file-server";
        Restart = "on-failure";
      };
    };


    systemd.services.polis-math = {
      description = "polis-math";
      after = [ "network.target" "polis-db-init.service" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "polis-db-init.service" ];
      environment = {
        MATH_ENV = "prod";
        # Needed because it writes a cache in HOME
        HOME = "%S/polis";
      };

      serviceConfig = {
        Type = "simple";
        User = "polis";
        Group = "polis";
        Restart = "on-failure";
        StateDirectory = "polis";
        # Sets DATABASE_URL
        EnvironmentFile = "%S/polis-db-init/env";
      };

      script = ''
        # TODO: https://github.com/compdemocracy/polis/blob/0500fec09e1607f731c3544511622910a35028ed/math/bin/run#L11
        while [ 1 ]
        do
          echo "                                                           "
          echo "XXXXXXXXXXXXXXXXXX REBOOTING MATH WORKER XXXXXXXXXXXXXXXXXX"
          echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
          echo "                                                           "
          timeout -s KILL 14400 ${pkgs.polis}/bin/polis-math
        done
      '';
    };

    systemd.services.polis-server = {
      description = "polis-server";
      after = [ "network.target" "polis-db-init.service" ];
      wants = [ "polis-db-init.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        MATH_ENV = "prod";
        SERVER_LOG_LEVEL = "info";

        API_PROD_HOSTNAME = config.services.polis.nginx.hostname;
        DOMAIN_OVERRIDE = config.services.polis.nginx.hostname;

        API_SERVER_PORT = "5000";

        STATIC_FILES_PORT = staticFilesPort;
        STATIC_FILES_HOST = "localhost";

        # TODO: Make this configurable
        # https://github.com/compdemocracy/polis/blob/edge/docs/configuration.md#email-addresses
        #EMAIL_TRANSPORT_TYPES = "aws-ses,mailgun";

        #EMAIL_TRANSPORT_TYPES = "aws-ses";
        #AWS_ACCESS_KEY_ID
        #AWS_SECRET_ACCESS_KEY

        #EMAIL_TRANSPORT_TYPES = "mailgun";
        #MAILGUN_API_KEY =
        #MAILGUN_DOMAIN =

        #ADMIN_EMAIL_DATA_EXPORT
        #ADMIN_EMAIL_DATA_EXPORT_TEST
        #ADMIN_EMAIL_EMAIL_TEST
        #ADMIN_EMAILS
        #POLIS_FROM_ADDRESS

      };
      serviceConfig = {
        Type = "simple";
        User = "polis";
        Group = "polis";
        ExecStart = "${pkgs.polis}/bin/polis-server";
        Restart = "on-failure";
        # Sets DATABASE_URL
        EnvironmentFile = "%S/polis-db-init/env";
      };
    };

  };

}
