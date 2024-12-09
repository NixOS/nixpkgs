{ config, pkgs, lib, ... }:
let
  cfg = config.services.paperless;

  defaultUser = "paperless";
  defaultFont = "${pkgs.liberation_ttf}/share/fonts/truetype/LiberationSerif-Regular.ttf";

  # Don't start a redis instance if the user sets a custom redis connection
  enableRedis = !(cfg.settings ? PAPERLESS_REDIS);
  redisServer = config.services.redis.servers.paperless;

  env = {
    PAPERLESS_DATA_DIR = cfg.dataDir;
    PAPERLESS_MEDIA_ROOT = cfg.mediaDir;
    PAPERLESS_CONSUMPTION_DIR = cfg.consumptionDir;
    PAPERLESS_THUMBNAIL_FONT_NAME = defaultFont;
    GUNICORN_CMD_ARGS = "--bind=${cfg.address}:${toString cfg.port}";
  } // lib.optionalAttrs (config.time.timeZone != null) {
    PAPERLESS_TIME_ZONE = config.time.timeZone;
  } // lib.optionalAttrs enableRedis {
    PAPERLESS_REDIS = "unix://${redisServer.unixSocket}";
  } // lib.optionalAttrs (cfg.settings.PAPERLESS_ENABLE_NLTK or true) {
    PAPERLESS_NLTK_DIR = pkgs.symlinkJoin {
      name = "paperless_ngx_nltk_data";
      paths = cfg.package.nltkData;
    };
  } // lib.optionalAttrs (cfg.openMPThreadingWorkaround) {
    OMP_NUM_THREADS = "1";
  } // (lib.mapAttrs (_: s:
    if (lib.isAttrs s || lib.isList s) then builtins.toJSON s
    else if lib.isBool s then lib.boolToString s
    else toString s
  ) cfg.settings);

  manage = pkgs.writeShellScript "manage" ''
    set -o allexport # Export the following env vars
    ${lib.toShellVars env}
    ${lib.optionalString (cfg.environmentFile != null) "source ${cfg.environmentFile}"}
    exec ${cfg.package}/bin/paperless-ngx "$@"
  '';

  defaultServiceConfig = {
    Slice = "system-paperless.slice";
    # Secure the services
    ReadWritePaths = [
      cfg.consumptionDir
      cfg.dataDir
      cfg.mediaDir
    ];
    CacheDirectory = "paperless";
    CapabilityBoundingSet = "";
    # ProtectClock adds DeviceAllow=char-rtc r
    DeviceAllow = "";
    EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateMounts = true;
    PrivateNetwork = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProtectClock = true;
    # Breaks if the home dir of the user is in /home
    # ProtectHome = true;
    ProtectHostname = true;
    ProtectSystem = "strict";
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    # Don't restrict ProcSubset because django-q requires read access to /proc/stat
    # to query CPU and memory information.
    # Note that /proc only contains processes of user `paperless`, so this is safe.
    # ProcSubset = "pid";
    RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SupplementaryGroups = lib.optional enableRedis redisServer.user;
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@privileged @setuid @keyring" ];
    UMask = "0066";
  };
in
{
  meta.maintainers = with lib.maintainers; [ leona SuperSandro2000 erikarvstedt ];

  imports = [
    (lib.mkRenamedOptionModule [ "services" "paperless-ng" ] [ "services" "paperless" ])
    (lib.mkRenamedOptionModule [ "services" "paperless" "extraConfig" ] [ "services" "paperless" "settings" ])
  ];

  options.services.paperless = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Paperless.

        When started, the Paperless database is automatically created if it doesn't
        exist and updated if the Paperless package has changed.
        Both tasks are achieved by running a Django migration.

        A script to manage the Paperless instance (by wrapping Django's manage.py) is linked to
        `''${dataDir}/paperless-manage`.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/paperless";
      description = "Directory to store the Paperless data.";
    };

    mediaDir = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.dataDir}/media";
      defaultText = lib.literalExpression ''"''${dataDir}/media"'';
      description = "Directory to store the Paperless documents.";
    };

    consumptionDir = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.dataDir}/consume";
      defaultText = lib.literalExpression ''"''${dataDir}/consume"'';
      description = "Directory from which new documents are imported.";
    };

    consumptionDirIsPublic = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether all users can write to the consumption dir.";
    };

    passwordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/keys/paperless-password";
      description = ''
        A file containing the superuser password.

        A superuser is required to access the web interface.
        If unset, you can create a superuser manually by running
        `''${dataDir}/paperless-manage createsuperuser`.

        The default superuser name is `admin`. To change it, set
        option {option}`settings.PAPERLESS_ADMIN_USER`.
        WARNING: When changing the superuser name after the initial setup, the old superuser
        will continue to exist.

        To disable login for the web interface, set the following:
        `settings.PAPERLESS_AUTO_LOGIN_USERNAME = "admin";`.
        WARNING: Only use this on a trusted system without internet access to Paperless.
      '';
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Web interface address.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 28981;
      description = "Web interface port.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = with lib.types; attrsOf (let
          typeList = [ bool float int str path package ];
        in oneOf (typeList ++ [ (listOf (oneOf typeList)) (attrsOf (oneOf typeList)) ]));
      };
      default = { };
      description = ''
        Extra paperless config options.

        See [the documentation](https://docs.paperless-ngx.com/configuration/) for available options.

        Note that some settings such as `PAPERLESS_CONSUMER_IGNORE_PATTERN` expect JSON values.
        Settings declared as lists or attrsets will automatically be serialised into JSON strings for your convenience.
      '';
      example = {
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_CONSUMER_IGNORE_PATTERN = [ ".DS_STORE/*" "desktop.ini" ];
        PAPERLESS_OCR_USER_ARGS = {
          optimize = 1;
          pdfa_image_compression = "lossless";
        };
      };
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = "User under which Paperless runs.";
    };

    package = lib.mkPackageOption pkgs "paperless-ngx" { } // {
      apply = pkg: pkg.override {
        tesseract5 = pkg.tesseract5.override {
          # always enable detection modules
          # tesseract fails to build when eng is not present
          enableLanguages = if cfg.settings ? PAPERLESS_OCR_LANGUAGE then
            lib.lists.unique (
              [ "equ" "osd" "eng" ]
              ++ lib.splitString "+" cfg.settings.PAPERLESS_OCR_LANGUAGE
            )
          else null;
        };
      };
    };

    openMPThreadingWorkaround = lib.mkEnableOption ''
      a workaround for document classifier timeouts.

      Paperless uses OpenBLAS via scikit-learn for document classification.

      The default is to use threading for OpenMP but this would cause the
      document classifier to spin on one core seemingly indefinitely if there
      are large amounts of classes per classification; causing it to
      effectively never complete due to running into timeouts.

      This sets `OMP_NUM_THREADS` to `1` in order to mitigate the issue. See
      https://github.com/NixOS/nixpkgs/issues/240591 for more information
    '' // lib.mkOption { default = true; };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/paperless";
      description = ''
        Path to a file containing extra paperless config options in the systemd `EnvironmentFile`
        format. Refer to the [documentation](https://docs.paperless-ngx.com/configuration/) for
        config options.

        This can be used to pass secrets to paperless without putting them in the Nix store.

        To set a database password, point `environmentFile` at a file containing:
        ```
        PAPERLESS_DBPASS=<pass>
        ```
      '';
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Configure local PostgreSQL database server for Paperless.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.redis.servers.paperless.enable = lib.mkIf enableRedis true;

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "paperless" ];
      ensureUsers = [{
        name = config.services.paperless.user;
        ensureDBOwnership = true;
      }];
    };

    services.paperless.settings = lib.mkIf cfg.database.createLocally {
      PAPERLESS_DBENGINE = "postgresql";
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_DBNAME = "paperless";
      PAPERLESS_DBUSER = "paperless";
    };

    systemd.slices.system-paperless = {
      description = "Paperless Document Management System Slice";
      documentation = [ "https://docs.paperless-ngx.com" ];
    };

    systemd.tmpfiles.settings."10-paperless" = let
      defaultRule = {
        inherit (cfg) user;
        inherit (config.users.users.${cfg.user}) group;
      };
    in {
      "${cfg.dataDir}".d = defaultRule;
      "${cfg.mediaDir}".d = defaultRule;
      "${cfg.consumptionDir}".d = if cfg.consumptionDirIsPublic then { mode = "777"; } else defaultRule;
    };

    systemd.services.paperless-scheduler = {
      description = "Paperless Celery Beat";
      wantedBy = [ "multi-user.target" ];
      wants = [ "paperless-consumer.service" "paperless-web.service" "paperless-task-queue.service" ];
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        ExecStart = "${cfg.package}/bin/celery --app paperless beat --loglevel INFO";
        Restart = "on-failure";
        LoadCredential = lib.optionalString (cfg.passwordFile != null) "PAPERLESS_ADMIN_PASSWORD:${cfg.passwordFile}";
      };
      environment = env;

      preStart = ''
        ln -sf ${manage} ${cfg.dataDir}/paperless-manage

        # Auto-migrate on first run or if the package has changed
        versionFile="${cfg.dataDir}/src-version"
        version=$(cat "$versionFile" 2>/dev/null || echo 0)

        if [[ $version != ${cfg.package.version} ]]; then
          ${cfg.package}/bin/paperless-ngx migrate

          # Parse old version string format for backwards compatibility
          version=$(echo "$version" | grep -ohP '[^-]+$')

          versionLessThan() {
            target=$1
            [[ $({ echo "$version"; echo "$target"; } | sort -V | head -1) != "$target" ]]
          }

          if versionLessThan 1.12.0; then
            # Reindex documents as mentioned in https://github.com/paperless-ngx/paperless-ngx/releases/tag/v1.12.1
            echo "Reindexing documents, to allow searching old comments. Required after the 1.12.x upgrade."
            ${cfg.package}/bin/paperless-ngx document_index reindex
          fi

          echo ${cfg.package.version} > "$versionFile"
        fi
      ''
      + lib.optionalString (cfg.passwordFile != null) ''
        export PAPERLESS_ADMIN_USER="''${PAPERLESS_ADMIN_USER:-admin}"
        PAPERLESS_ADMIN_PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/PAPERLESS_ADMIN_PASSWORD")
        export PAPERLESS_ADMIN_PASSWORD
        superuserState="$PAPERLESS_ADMIN_USER:$PAPERLESS_ADMIN_PASSWORD"
        superuserStateFile="${cfg.dataDir}/superuser-state"

        if [[ $(cat "$superuserStateFile" 2>/dev/null) != "$superuserState" ]]; then
          ${cfg.package}/bin/paperless-ngx manage_superuser
          echo "$superuserState" > "$superuserStateFile"
        fi
      '';
      requires = lib.optional cfg.database.createLocally "postgresql.service";
      after = lib.optional enableRedis "redis-paperless.service"
        ++ lib.optional cfg.database.createLocally "postgresql.service";
    };

    systemd.services.paperless-task-queue = {
      description = "Paperless Celery Workers";
      requires = lib.optional cfg.database.createLocally "postgresql.service";
      after = [ "paperless-scheduler.service" ]
        ++ lib.optional cfg.database.createLocally "postgresql.service";
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        ExecStart = "${cfg.package}/bin/celery --app paperless worker --loglevel INFO";
        Restart = "on-failure";
        # The `mbind` syscall is needed for running the classifier.
        SystemCallFilter = defaultServiceConfig.SystemCallFilter ++ [ "mbind" ];
        # Needs to talk to mail server for automated import rules
        PrivateNetwork = false;
      };
      environment = env;
    };

    systemd.services.paperless-consumer = {
      description = "Paperless document consumer";
      # Bind to `paperless-scheduler` so that the consumer never runs
      # during migrations
      bindsTo = [ "paperless-scheduler.service" ];
      requires = lib.optional cfg.database.createLocally "postgresql.service";
      after = [ "paperless-scheduler.service" ]
        ++ lib.optional cfg.database.createLocally "postgresql.service";
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        ExecStart = "${cfg.package}/bin/paperless-ngx document_consumer";
        Restart = "on-failure";
      };
      environment = env;
      # Allow the consumer to access the private /tmp directory of the server.
      # This is required to support consuming files via a local folder.
      unitConfig.JoinsNamespaceOf = "paperless-task-queue.service";
    };

    systemd.services.paperless-web = {
      description = "Paperless web server";
      # Bind to `paperless-scheduler` so that the web server never runs
      # during migrations
      bindsTo = [ "paperless-scheduler.service" ];
      requires = lib.optional cfg.database.createLocally "postgresql.service";
      after = [ "paperless-scheduler.service" ]
        ++ lib.optional cfg.database.createLocally "postgresql.service";
      # Setup PAPERLESS_SECRET_KEY.
      # If this environment variable is left unset, paperless-ngx defaults
      # to a well-known value, which is insecure.
      script = let
        secretKeyFile = "${cfg.dataDir}/nixos-paperless-secret-key";
      in ''
        if [[ ! -f '${secretKeyFile}' ]]; then
          (
            umask 0377
            tr -dc A-Za-z0-9 < /dev/urandom | head -c64 | ${pkgs.moreutils}/bin/sponge '${secretKeyFile}'
          )
        fi
        PAPERLESS_SECRET_KEY="$(cat '${secretKeyFile}')"
        export PAPERLESS_SECRET_KEY
        if [[ ! $PAPERLESS_SECRET_KEY ]]; then
          echo "PAPERLESS_SECRET_KEY is empty, refusing to start."
          exit 1
        fi
        exec ${cfg.package.python.pkgs.gunicorn}/bin/gunicorn \
          -c ${cfg.package}/lib/paperless-ngx/gunicorn.conf.py paperless.asgi:application
      '';
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        Restart = "on-failure";

        LimitNOFILE = 65536;
        # gunicorn needs setuid, liblapack needs mbind
        SystemCallFilter = defaultServiceConfig.SystemCallFilter ++ [ "@setuid mbind" ];
        # Needs to serve web page
        PrivateNetwork = false;
      };
      environment = env // {
        PYTHONPATH = "${cfg.package.python.pkgs.makePythonPath cfg.package.propagatedBuildInputs}:${cfg.package}/lib/paperless-ngx/src";
      };
      # Allow the web interface to access the private /tmp directory of the server.
      # This is required to support uploading files via the web interface.
      unitConfig.JoinsNamespaceOf = "paperless-task-queue.service";
    };

    users = lib.optionalAttrs (cfg.user == defaultUser) {
      users.${defaultUser} = {
        group = defaultUser;
        uid = config.ids.uids.paperless;
        home = cfg.dataDir;
      };

      groups.${defaultUser} = {
        gid = config.ids.gids.paperless;
      };
    };
  };
}
