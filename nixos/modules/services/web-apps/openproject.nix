{
  lib,
  config,
  pkgs,
  ...
}:

let

  postgresqlPackage =
    if config.services.postgresql.enable then
      config.services.postgresql.package
    else
      pkgs.postgresql_18;
  pgVersion = lib.head (lib.splitString "." postgresqlPackage.version);

  cfg = config.services.openproject;

  configEnv = lib.concatMapAttrs (
    name: value:
    lib.optionalAttrs (value != null) {
      ${name} = if lib.isBool value then lib.boolToString value else toString value;
    }
  ) cfg.settings;

  bundleBin = "${lib.getExe' pkgs.openproject.passthru.rubyEnv.wrappedRuby "bundle"}";

  defaultServiceConfig = {
    User = "openproject";
    Group = "openproject";
    WorkingDirectory = "${pkgs.openproject}";
    StateDirectory = cfg.stateDir;
    # Service hardening
    ReadWritePaths = [ cfg.stateDir ];
    CacheDirectory = "openproject";
    AmbientCapabilities = "";
    CapabilityBoundingSet = "";
    # ProtectClock adds DeviceAllow=char-rtc r
    DeviceAllow = "";
    DevicePolicy = "closed";
    LockPersonality = true;
    # Loosening setting, required by Ruby daemon
    MemoryDenyWriteExecute = false;
    NoNewPrivileges = true;
    RemoveIPC = true;
    PrivateDevices = true;
    PrivateMounts = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProtectClock = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectSystem = "strict";
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      # Loosening setting, required by Ruby daemon
      #"~@privileged @setuid @keyring"
    ];
    UMask = "0077";
  };

in
{
  options.services.openproject = {

    enable = lib.mkEnableOption "OpenProject modern project management web app";

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/openproject";
      description = ''
        OpenProject state directory. Configuration, repositories and
        logs, among other things, are stored here.

        The directory will be created automatically if it doesn't
        exist already. Its parent directories must be owned by
        either `root` or the user openproject.
      '';
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to create the database and database user locally.
        '';
      };
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.bool
              lib.types.int
              lib.types.port
              lib.types.path
            ]
          )
        );
        options = {
          OPENPROJECT_HOST__NAME = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            description = "Hostname to use";
          };
          PORT = lib.mkOption {
            type = lib.types.port;
            default = 6346;
            description = "IP address and port to bind to";
            example = "127.0.0.1:8080";
          };
          DATABASE_URL = lib.mkOption {
            type = lib.types.str;
            default = "postgres:///openproject?host=/run/postgresql&username=openproject&pool=20&encoding=unicode&reconnect=true";
            description = ''
              Database connection scheme. The default specifies the
              connection through a local socket.
            '';
          };
        };
      };
      default = { };
      description = ''
        Extra configuration options to append or override.
        For available and default option values see
        [upstream configuration file](https://www.openproject.org/docs/installation-and-operations/configuration/environment/).
      '';
    };

    secrets.keyBaseFile = lib.mkOption {
      type = lib.types.str;
      description = "TODO";
    };
  };

  config = lib.mkIf cfg.enable {

    services.openproject.settings = lib.mkMerge [
      {
        OPENPROJECT_RAILS_CACHE_STORE = "memcache";
        OPENPROJECT_CACHE__MEMCACHE__SERVER = "unix:///run/memcached/memcached.sock";
        OPENPROJECT_CACHE__NAMESPACE = "openproject";
        RAILS_ENV = "production";
        BUNDLE_WITHOUT = "development:test";
        PGVERSION = pgVersion;
        CURRENT_PGVERSION = pgVersion;
        NEXT_PGVERSION = pgVersion;
        # FIXME this is not an offical variable
        SECRET_KEY_BASE_FILE = cfg.secrets.keyBaseFile;
        LD_PRELOAD = "${pkgs.jemalloc}/lib/libjemalloc.so";
      }
    ];

    systemd.tmpfiles.rules = [
      "L+ /run/openproject - - - - ${cfg.stateDir}"
      "d ${cfg.stateDir} 0755 openproject openproject -"
      "d ${cfg.stateDir}/tmp 0755 openproject openproject -"
      "d ${cfg.stateDir}/files 0755 openproject openproject -"
    ];

    systemd.services."openproject-seeder" = {
      serviceConfig = defaultServiceConfig // {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "openproject-seeder" ''
          set -o errexit -o pipefail -o nounset
          shopt -s inherit_errexit

          # Auto-migrate on first run or if the package has changed
          versionFile="${cfg.stateDir}/src-version"
          version=$(cat "$versionFile" 2>/dev/null || echo 0)
          #export SECRET_KEY_BASE=$(cat $SECRET_KEY_BASE_FILE)
          export SECRET_KEY_BASE=1

          if [[ $version == 0 ]]; then
            echo "Initialising database and running seed..."
            DISABLE_DATABASE_ENVIRONMENT_CHECK=1 ${bundleBin} exec rake db:migrate db:seed
            echo ${pkgs.openproject.version} > "$versionFile"
          fi

          if [[ $version != ${pkgs.openproject.version} ]]; then
            echo "Executing database migration and database seed..."
            ${bundleBin} exec rake db:migrate
            echo ${pkgs.openproject.version} > "$versionFile"
          fi
        '';
      };
      wants = lib.optional cfg.database.createLocally "postgresql.target";
      after = lib.optional cfg.database.createLocally "postgresql.target";
      environment = configEnv;
    };

    systemd.services."openproject-web" = {
      serviceConfig = defaultServiceConfig // {
        ExecStart = pkgs.writeShellScript "openproject-web" ''
          set -o errexit -o pipefail -o nounset
          shopt -s inherit_errexit

          # TODO let nginx handle this
          export OPENPROJECT_ENABLE__INTERNAL__ASSETS__SERVER=true
          export SECRET_KEY_BASE=$(cat $SECRET_KEY_BASE_FILE)

          ${bundleBin} exec rails server -u puma
        '';
      };
      bindsTo = [ "openproject-seeder.service" ];
      after = [ "openproject-seeder.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = configEnv;
    };

    systemd.services."openproject-worker" = {
      serviceConfig = defaultServiceConfig // {
        ExecStart = pkgs.writeShellScript "openproject-worker" ''
          set -o errexit -o pipefail -o nounset
          shopt -s inherit_errexit

          export SECRET_KEY_BASE=$(cat $SECRET_KEY_BASE_FILE)

          ${bundleBin} exec good_job start
        '';
      };
      bindsTo = [ "openproject-seeder.service" ];
      after = [ "openproject-seeder.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = configEnv;
    };

    systemd.services."openproject-cron" = {
      serviceConfig = defaultServiceConfig // {
        ExecStart = pkgs.writeShellScript "openproject-cron" ''
          set -o errexit -o pipefail -o nounset
          shopt -s inherit_errexit

          ${bundleBin} exec rake redmine:email:receive_imap \
            host="$IMAP_HOST" \
            username="$IMAP_USERNAME" \
            password="$IMAP_PASSWORD" \
            ssl="$IMAP_SSL" \
            ssl_verification="$IMAP_SSL_VERIFICATION" \
            port="$IMAP_PORT" \
            folder="$IMAP_FOLDER" \
            project="$IMAP_ATTR_PROJECT" \
            category="$IMAP_ATTR_CATEGORY" \
            priority="$IMAP_ATTR_PRIORITY" \
            status="$IMAP_ATTR_STATUS" \
            version="$IMAP_ATTR_VERSION" \
            type="$IMAP_ATTR_TYPE" \
            assigned_to="$IMAP_ATTR_ASSIGNED_TO" \
            unknown_user="$IMAP_UNKNOWN_USER" \
            no_permission_check="$IMAP_NO_PERMISSION_CHECK" \
            move_on_success="$IMAP_MOVE_ON_SUCCESS" \
            move_on_failure="$IMAP_MOVE_ON_FAILURE" \
            allow_override="$IMAP_ALLOW_OVERRIDE"
        '';
      };
      bindsTo = [ "openproject-seeder.service" ];
      after = [ "openproject-seeder.service" ];
      environment = configEnv;
    };

    systemd.timers."openproject-cron" = lib.mkIf (cfg.settings.IMAP_HOST or null != null) {
      timerConfig.OnActiveSec = "30 seconds";
      timerConfig.OnUnitInactiveSec = "5 minutes";
      wantedBy = [ "multi-user.target" ];
      after = [ "openproject-seeder.service" ];
    };

    services.memcached = {
      enable = true;
      enableUnixSocket = true;
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "openproject" ];
      ensureUsers = [
        {
          name = "openproject";
          ensureDBOwnership = true;
        }
      ];
    };

    users = {
      groups.openproject = { };
      users.openproject = {
        isSystemUser = true;
        group = "openproject";
      };
    };

  };
}
