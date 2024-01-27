{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.paperless;
  pkg = cfg.package;

  defaultUser = "paperless";
  nltkDir = "/var/cache/paperless/nltk";
  defaultFont = "${pkgs.liberation_ttf}/share/fonts/truetype/LiberationSerif-Regular.ttf";

  # Don't start a redis instance if the user sets a custom redis connection
  enableRedis = !(cfg.settings ? PAPERLESS_REDIS);
  redisServer = config.services.redis.servers.paperless;

  env = {
    PAPERLESS_DATA_DIR = cfg.dataDir;
    PAPERLESS_MEDIA_ROOT = cfg.mediaDir;
    PAPERLESS_CONSUMPTION_DIR = cfg.consumptionDir;
    PAPERLESS_NLTK_DIR = nltkDir;
    PAPERLESS_THUMBNAIL_FONT_NAME = defaultFont;
    GUNICORN_CMD_ARGS = "--bind=${cfg.address}:${toString cfg.port}";
  } // optionalAttrs (config.time.timeZone != null) {
    PAPERLESS_TIME_ZONE = config.time.timeZone;
  } // optionalAttrs enableRedis {
    PAPERLESS_REDIS = "unix://${redisServer.unixSocket}";
  } // (lib.mapAttrs (_: s:
    if (lib.isAttrs s || lib.isList s) then builtins.toJSON s
    else if lib.isBool s then lib.boolToString s
    else toString s
  ) cfg.settings);

  manage = pkgs.writeShellScript "manage" ''
    set -o allexport # Export the following env vars
    ${lib.toShellVars env}
    exec ${pkg}/bin/paperless-ngx "$@"
  '';

  # Secure the services
  defaultServiceConfig = {
    ReadWritePaths = [
      cfg.consumptionDir
      cfg.dataDir
      cfg.mediaDir
    ];
    CacheDirectory = "paperless";
    CapabilityBoundingSet = "";
    # ProtectClock adds DeviceAllow=char-rtc r
    DeviceAllow = "";
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
    SupplementaryGroups = optional enableRedis redisServer.user;
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@privileged @setuid @keyring" ];
    UMask = "0066";
  };
in
{
  meta.maintainers = with maintainers; [ erikarvstedt Flakebi leona ];

  imports = [
    (mkRenamedOptionModule [ "services" "paperless-ng" ] [ "services" "paperless" ])
    (mkRenamedOptionModule [ "services" "paperless" "extraConfig" ] [ "services" "paperless" "settings" ])
  ];

  options.services.paperless = {
    enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable Paperless.

        When started, the Paperless database is automatically created if it doesn't
        exist and updated if the Paperless package has changed.
        Both tasks are achieved by running a Django migration.

        A script to manage the Paperless instance (by wrapping Django's manage.py) is linked to
        `''${dataDir}/paperless-manage`.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/paperless";
      description = lib.mdDoc "Directory to store the Paperless data.";
    };

    mediaDir = mkOption {
      type = types.str;
      default = "${cfg.dataDir}/media";
      defaultText = literalExpression ''"''${dataDir}/media"'';
      description = lib.mdDoc "Directory to store the Paperless documents.";
    };

    consumptionDir = mkOption {
      type = types.str;
      default = "${cfg.dataDir}/consume";
      defaultText = literalExpression ''"''${dataDir}/consume"'';
      description = lib.mdDoc "Directory from which new documents are imported.";
    };

    consumptionDirIsPublic = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Whether all users can write to the consumption dir.";
    };

    passwordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/keys/paperless-password";
      description = lib.mdDoc ''
        A file containing the superuser password.

        A superuser is required to access the web interface.
        If unset, you can create a superuser manually by running
        `''${dataDir}/paperless-manage createsuperuser`.

        The default superuser name is `admin`. To change it, set
        option {option}`extraConfig.PAPERLESS_ADMIN_USER`.
        WARNING: When changing the superuser name after the initial setup, the old superuser
        will continue to exist.

        To disable login for the web interface, set the following:
        `extraConfig.PAPERLESS_AUTO_LOGIN_USERNAME = "admin";`.
        WARNING: Only use this on a trusted system without internet access to Paperless.
      '';
    };

    address = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc "Web interface address.";
    };

    port = mkOption {
      type = types.port;
      default = 28981;
      description = lib.mdDoc "Web interface port.";
    };

    settings = mkOption {
      type = lib.types.submodule {
        freeformType = with lib.types; attrsOf (let
          typeList = [ bool float int str path package ];
        in oneOf (typeList ++ [ (listOf (oneOf typeList)) (attrsOf (oneOf typeList)) ]));
      };
      default = { };
      description = lib.mdDoc ''
        Extra paperless config options.

        See [the documentation](https://docs.paperless-ngx.com/configuration/) for available options.

        Note that some settings such as `PAPERLESS_CONSUMER_IGNORE_PATTERN` expect JSON values.
        Settings declared as lists or attrsets will automatically be serialised into JSON strings for your convenience.
      '';
      example = {
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_DBHOST = "/run/postgresql";
        PAPERLESS_CONSUMER_IGNORE_PATTERN = [ ".DS_STORE/*" "desktop.ini" ];
        PAPERLESS_OCR_USER_ARGS = {
          optimize = 1;
          pdfa_image_compression = "lossless";
        };
      };
    };

    user = mkOption {
      type = types.str;
      default = defaultUser;
      description = lib.mdDoc "User under which Paperless runs.";
    };

    package = mkPackageOption pkgs "paperless-ngx" { };
  };

  config = mkIf cfg.enable {
    services.redis.servers.paperless.enable = mkIf enableRedis true;

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
      "d '${cfg.mediaDir}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
      (if cfg.consumptionDirIsPublic then
        "d '${cfg.consumptionDir}' 777 - - - -"
      else
        "d '${cfg.consumptionDir}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
      )
    ];

    systemd.services.paperless-scheduler = {
      description = "Paperless Celery Beat";
      wantedBy = [ "multi-user.target" ];
      wants = [ "paperless-consumer.service" "paperless-web.service" "paperless-task-queue.service" ];
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        ExecStart = "${pkg}/bin/celery --app paperless beat --loglevel INFO";
        Restart = "on-failure";
      };
      environment = env;

      preStart = ''
        ln -sf ${manage} ${cfg.dataDir}/paperless-manage

        # Auto-migrate on first run or if the package has changed
        versionFile="${cfg.dataDir}/src-version"
        version=$(cat "$versionFile" 2>/dev/null || echo 0)

        if [[ $version != ${pkg.version} ]]; then
          ${pkg}/bin/paperless-ngx migrate

          # Parse old version string format for backwards compatibility
          version=$(echo "$version" | grep -ohP '[^-]+$')

          versionLessThan() {
            target=$1
            [[ $({ echo "$version"; echo "$target"; } | sort -V | head -1) != "$target" ]]
          }

          if versionLessThan 1.12.0; then
            # Reindex documents as mentioned in https://github.com/paperless-ngx/paperless-ngx/releases/tag/v1.12.1
            echo "Reindexing documents, to allow searching old comments. Required after the 1.12.x upgrade."
            ${pkg}/bin/paperless-ngx document_index reindex
          fi

          echo ${pkg.version} > "$versionFile"
        fi
      ''
      + optionalString (cfg.passwordFile != null) ''
        export PAPERLESS_ADMIN_USER="''${PAPERLESS_ADMIN_USER:-admin}"
        export PAPERLESS_ADMIN_PASSWORD=$(cat "${cfg.dataDir}/superuser-password")
        superuserState="$PAPERLESS_ADMIN_USER:$PAPERLESS_ADMIN_PASSWORD"
        superuserStateFile="${cfg.dataDir}/superuser-state"

        if [[ $(cat "$superuserStateFile" 2>/dev/null) != $superuserState ]]; then
          ${pkg}/bin/paperless-ngx manage_superuser
          echo "$superuserState" > "$superuserStateFile"
        fi
      '';
    } // optionalAttrs enableRedis {
      after = [ "redis-paperless.service" ];
    };

    systemd.services.paperless-task-queue = {
      description = "Paperless Celery Workers";
      after = [ "paperless-scheduler.service" ];
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        ExecStart = "${pkg}/bin/celery --app paperless worker --loglevel INFO";
        Restart = "on-failure";
        # The `mbind` syscall is needed for running the classifier.
        SystemCallFilter = defaultServiceConfig.SystemCallFilter ++ [ "mbind" ];
        # Needs to talk to mail server for automated import rules
        PrivateNetwork = false;
      };
      environment = env;
    };

    # Reading the user-provided password file requires root access
    systemd.services.paperless-copy-password = mkIf (cfg.passwordFile != null) {
      requiredBy = [ "paperless-scheduler.service" ];
      before = [ "paperless-scheduler.service" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.coreutils}/bin/install --mode 600 --owner '${cfg.user}' --compare \
            '${cfg.passwordFile}' '${cfg.dataDir}/superuser-password'
        '';
        Type = "oneshot";
      };
    };

    # Download NLTK corpus data
    systemd.services.paperless-download-nltk-data = {
      wantedBy = [ "paperless-scheduler.service" ];
      before = [ "paperless-scheduler.service" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        Type = "oneshot";
        # Enable internet access
        PrivateNetwork = false;
        ExecStart = let pythonWithNltk = pkg.python.withPackages (ps: [ ps.nltk ]); in ''
          ${pythonWithNltk}/bin/python -m nltk.downloader -d '${nltkDir}' punkt snowball_data stopwords
        '';
      };
    };

    systemd.services.paperless-consumer = {
      description = "Paperless document consumer";
      # Bind to `paperless-scheduler` so that the consumer never runs
      # during migrations
      bindsTo = [ "paperless-scheduler.service" ];
      after = [ "paperless-scheduler.service" ];
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        ExecStart = "${pkg}/bin/paperless-ngx document_consumer";
        Restart = "on-failure";
      };
      environment = env;
    };

    systemd.services.paperless-web = {
      description = "Paperless web server";
      # Bind to `paperless-scheduler` so that the web server never runs
      # during migrations
      bindsTo = [ "paperless-scheduler.service" ];
      after = [ "paperless-scheduler.service" ];
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
        export PAPERLESS_SECRET_KEY=$(cat '${secretKeyFile}')
        if [[ ! $PAPERLESS_SECRET_KEY ]]; then
          echo "PAPERLESS_SECRET_KEY is empty, refusing to start."
          exit 1
        fi
        exec ${pkg.python.pkgs.gunicorn}/bin/gunicorn \
          -c ${pkg}/lib/paperless-ngx/gunicorn.conf.py paperless.asgi:application
      '';
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        Restart = "on-failure";

        # gunicorn needs setuid, liblapack needs mbind
        SystemCallFilter = defaultServiceConfig.SystemCallFilter ++ [ "@setuid mbind" ];
        # Needs to serve web page
        PrivateNetwork = false;
      } // lib.optionalAttrs (cfg.port < 1024) {
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };
      environment = env // {
        PYTHONPATH = "${pkg.python.pkgs.makePythonPath pkg.propagatedBuildInputs}:${pkg}/lib/paperless-ngx/src";
      };
      # Allow the web interface to access the private /tmp directory of the server.
      # This is required to support uploading files via the web interface.
      unitConfig.JoinsNamespaceOf = "paperless-task-queue.service";
    };

    users = optionalAttrs (cfg.user == defaultUser) {
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
