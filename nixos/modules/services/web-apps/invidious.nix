{ lib, config, pkgs, ... }:
let
  cfg = config.services.invidious;

  # TODO: Add a test

  inherit ((import ../../../../lib).types) oneOf;

  serviceConfig = {

    services.invidious.settings = {
      # These defaults are needed because otherwise invidious doesn't start
      channel_threads = lib.mkDefault 1;
      feed_threads = lib.mkDefault 1;
      full_refresh = lib.mkDefault false;

      # The cfg.port option is provided such that the value can be used to open
      # the port in the firewall or be forwarded to with a web server
      external_port = lib.mkDefault cfg.port;

      # Automatically initializes the database if necessary
      check_tables = true;
    };

    systemd.services.invidious = {
      description = "Invidious (An alternative YouTube front-end)";
      wants = [ "network-online.target" ];
      after = [ "syslog.target" "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      # https://github.com/crystal-lang/crystal/issues/8126
      # TODO: Can I remove this?
      environment.HOME = "/var/empty";

      serviceConfig = {
        RestartSec = "2s";
        DynamicUser = true;
        ExecStart = "${pkgs.invidious}/bin/invidious";
        WorkingDirectory = pkgs.runCommandNoCC "invidious-working-dir" {
          config = builtins.toJSON cfg.settings;
          passAsFile = "config";
        } ''
          mkdir -p $out/config

          # Invidious reads the configuration from this path
          mv "$configPath" $out/config/config.yml

          # Needed for check_tables to be able to initialize the database
          ln -s ${pkgs.invidious}/share/invidious/config/sql $out/config
        '';
      };
    };

  };

  # Settings necessary for running with an automatically managed local database
  localDatabaseConfig = let
    databaseUser = "kemal";
    databaseName = "invidious";
  in {

    # While Invidious does support using a different non-local database, the
    # migration scripts are hardcoded to this. So to get this working you'd have
    # to run the (potentially adjusted) migration scripts manually on the other
    # host, and that in sync with the Invidious update on this host, which would
    # be a hassle. So for simplicity and better user experience, this module
    # always uses a local database which gets managed fully automatic.

    services.invidious.settings.db = {
      user = databaseUser;
      dbname = databaseName;
      port = config.services.postgresql.port;
      # Blank for unix sockets, see https://github.com/will/crystal-pg/blob/1548bb2552104241a8b020869f1a64c9744cfe44/src/pq/conninfo.cr#L100-L108
      host = "";
      # Not needed because peer authentication is enabled
      password = "";
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ databaseName ];
      ensureUsers = [{
        name = databaseUser;
        ensurePermissions = {
          "DATABASE ${databaseName}" = "ALL PRIVILEGES";
        };
      }];
      # This is only needed because the unix user invidious isn't the same as
      # the database user. This tells postgres to map one to the other
      identMap = ''
        invidious invidious ${databaseUser}
      '';
      # And this specifically enables peer authentication for only this database
      # , which allows passwordless authentication over the postgres unix socket
      # for the user map given above
      authentication = ''
        local ${databaseName} ${databaseUser} peer map=invidious
      '';
    };

    systemd.services.invidious-db-clean = {
      description = "Invidious database cleanup";
      documentation = [ "https://github.com/omarroth/invidious/wiki/Database-Information-and-Maintenance" ];
      startAt = lib.mkDefault "weekly";
      path = [ config.services.postgresql.package ];
      script = ''
        psql ${databaseName} ${databaseUser} -c "DELETE FROM nonces * WHERE expire < current_timestamp"
        psql ${databaseName} ${databaseUser} -c "TRUNCATE TABLE videos"
      '';
      serviceConfig = {
        DynamicUser = true;
        # TODO: Does this work? Can systemd make this service run as the same user?
        User = "invidious";
      };
    };

    systemd.services.invidious = {
      # TODO: Add description and docs
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ config.services.postgresql.package ];

      # This script automatically migrates the database if necessary
      preStart = ''
        set -x
        configDir=${pkgs.invidious}/share/invidious/config
        pastcommitsFile=${pkgs.invidious}/nix-support/invidious/pastcommits
        versionFile=$STATE_DIRECTORY/database-version
        currentVersion=$(tail -1 "$pastcommitsFile")

        if ! [ -f "$versionFile" ]; then

          echo "$currentVersion" > "$versionFile"
          echo "Initialized database version at commit $currentVersion"

        else

          previousVersion=$(cat "$versionFile")

          if [ "$previousVersion" = "$currentVersion" ]; then

            echo "Database up-to-date, no automatic migration necessary"

          else

            echo "Database is from version $previousVersion while the current " \
              "version is $currentVersion"

            # This means either we're running a newer version in which case we
            # should run the migration scripts, or an older version in which
            # case this might not be able to handle the newer database so we
            # should warn for that

            # Finds all commits that happened between the $previousVersion and
            # the $currentVersion
            commits=$(sed -e "0,/$previousVersion/d" "$pastcommitsFile")

            # If we couldn't find any commits, this means we're running a
            # version older than the database
            if [ -z "$commits" ]; then
              echo "Database version is newer than the Invidious version " \
                ", problems may occur because of this."
            else
              for commit in $commits; do
                migrationScript=$configDir/migrate-scripts/migrate-db-$commit.sh
                if [ -f "$migrationScript" ]; then
                  echo "Running migration script $migrationScript"
                  "$migrationScript"
                fi
                echo "$commit" > "$versionFile"
              done
              echo "Finished running all migration scripts"
            fi
          fi
        fi
      '';

      serviceConfig = {
        User = "invidious";
        # Only used for storing database version
        StateDirectory = "invidious";
      };
    };
  };

  nginxConfig = lib.mkIf cfg.nginx {

    services.invidious.settings = {
      #https_only = config.services.nginx.virtualHosts.${cfg.settings.domain}.forceSSL;

      /*
      TODO: What does this do?
      hsts:              {type: Bool?, default: true}, # Enables 'Strict-Transport-Security'. Ensure that `domain` and all subdomains are served securely

      Turn on forceSSL if hsts is enabled? Can hsts = true and forceSSL = false work? Not sure
      If it can work, don't do that
      If it can't, then do this or turn on hsts if forceSSL is enabled?
      */
    };

    systemd.services.invidious.after = [ "nginx.service" ];

    services.nginx = {
      enable = true;
      virtualHosts.${cfg.settings.domain or null} = {
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
        forceSSL = lib.mkIf (cfg.settings.https_only or false) true;
      };
    };

    assertions = [{
      assertion = cfg.settings ? domain;
      message = "To use services.invidious.nginx, you need to set services.invidious.settings.domain";
    }];
  };

in {

  options.services.invidious = {
    enable = lib.mkEnableOption "Invidious";

    settings =
      let jsonType = with lib.types; nullOr (oneOf
        [ bool str int (listOf jsonType) (attrsOf jsonType) ] ) // {
          description = "JSON (null, bool, string, int, list of JSON or attrs of JSON)";
        };
      in lib.mkOption {
        type = jsonType;
        default = {};
        description = ''
          Invidious settings, see <xlink href="https://github.com/omarroth/invidious/wiki/Configuration"/>.
        '';
      };

    port = lib.mkOption {
      type = lib.types.port;
      # Default from https://github.com/kemalcr/kemal/blob/15022c25b824ecbfe465862bfa8a8e37a4b6ab40/src/kemal/config.cr#L31
      default = 3000;
      description = ''
        Port Invidious should listen on. To allow access from outside, you can
        use either <option>services.invidious.nginx</option> or add <literal>
        config.services.invidious.port</literal> to <option>
        networking.firewall.allowedTCPPorts</option>.
      '';
    };

    nginx = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Integrate Invidious with nginx by defining a proxy pass to it from the
        domain specified in <option>services.invidious.settings.domain</option>,
        enabling ACME integration and forcing SSL. Further configuration can be
        done through <option>
        services.nginx.virtualHosts.''${config.services.invidious.settings.domain}.*
        </option>.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    serviceConfig
    localDatabaseConfig
    nginxConfig
  ]);
}
