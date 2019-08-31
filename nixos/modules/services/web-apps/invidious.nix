{ lib, config, pkgs, ... }:
let
  cfg = config.services.invidious;

  # Default from https://github.com/kemalcr/kemal/blob/15022c25b824ecbfe465862bfa8a8e37a4b6ab40/src/kemal/config.cr#L31
  port = cfg.settings.external_port or 3000;

  databaseUser = "kemal";
  databaseName = "invidious";

  # TODO: Automatic db cleanup as described in https://github.com/omarroth/invidious/wiki/Database-Information-and-Maintenance
  # TODO: Add a test
  # TODO: Detect rollbacks, warn for potential problems

  workingDir = pkgs.runCommandNoCC "invidious-config" {
    config = builtins.toJSON cfg.settings;
    passAsFile = "config";
  } ''
    mkdir -p $out/config
    mv "$configPath" $out/config/config.yml
  '';

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

    # TODO: Only export a `port` option? Different web servers?
    nginx = lib.mkEnableOption "nginx";

  };

  config = lib.mkIf cfg.enable {

    services.invidious.settings = {
      channel_threads = lib.mkDefault 1;
      feed_threads = lib.mkDefault 1;
      full_refresh = lib.mkDefault false;

      db = {
        user = databaseUser;
        dbname = databaseName;
        port = config.services.postgresql.port;
        host = ""; # Blank for unix sockets if possible, see https://github.com/will/crystal-pg/blob/1548bb2552104241a8b020869f1a64c9744cfe44/src/pq/conninfo.cr#L100-L108
        password = ""; # Not needed because peer authentication is enabled
      };
    };

    systemd.services.invidious = {
      description = "Invidious (An alternative YouTube front-end)";
      after = [ "postgresql.service" "syslog.target" "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ config.services.postgresql.package ];

      preStart = ''
        configDir=${pkgs.invidious}/share/invidious/config
        pastcommitsFile=${pkgs.invidious}/nix-support/invidious/pastcommits
        versionFile=$STATE_DIRECTORY/database-version

        if ! [ -f "$versionFile" ]; then

          echo "Creating initial database tables"
          for sqlFile in "$configDir"/sql/*; do
            psql invidious kemal < "$sqlFile"
          done

          commit=$(tail -1 "$pastcommitsFile")
          echo "Initialized database at commit $commit"
          echo "$commit" > "$versionFile"

        else

          previous=$(cat "$versionFile")
          current=$(tail -1 "$pastcommitsFile")

          if [ "$previous" != "$current" ]; then
            echo "Database is from version $previous while the current " \
              "version is $current, running migration scripts if any"

            commits=$(sed -e "0,/$previous/d" "$pastcommitsFile")
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
      '';

      # https://github.com/crystal-lang/crystal/issues/8126
      environment.HOME = "/var/empty";

      serviceConfig = {
        RestartSec = "2s";
        User = "invidious";
        Group = "invidious";
        DynamicUser = true;
        # Used for storing database version
        StateDirectory = "invidious";
        ExecStart = "${pkgs.invidious}/bin/invidious";
        WorkingDirectory = workingDir;
      };

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
      authentication = ''
        local ${databaseName} ${databaseUser} peer map=invidious
      '';
      identMap = ''
        invidious invidious ${databaseUser}
      '';
    };

    services.nginx = lib.mkIf cfg.nginx {
      enable = true;
      virtualHosts.${cfg.settings.domain} = {
        # TODO: Should this be the other way around? set https_only if nginx enabled and forceSSL true?
        forceSSL = lib.mkIf (cfg.settings ? https_only) cfg.settings.https_only;
        locations."/".proxyPass = "http://localhost:${port}";
      };

    };

    assertions = [{
      assertion = cfg.nginx -> cfg.settings ? domain;
      message = "To use services.invidious.nginx, you need to set services.invidious.settings.domain";
    }];

  };

}
