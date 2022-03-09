{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.paperless-ng;

  defaultUser = "paperless";

  hasCustomRedis = hasAttr "PAPERLESS_REDIS" cfg.extraConfig;

  env = {
    PAPERLESS_DATA_DIR = cfg.dataDir;
    PAPERLESS_MEDIA_ROOT = cfg.mediaDir;
    PAPERLESS_CONSUMPTION_DIR = cfg.consumptionDir;
    GUNICORN_CMD_ARGS = "--bind=${cfg.address}:${toString cfg.port}";
  } // (
    lib.mapAttrs (_: toString) cfg.extraConfig
  ) // (optionalAttrs (!hasCustomRedis) {
    PAPERLESS_REDIS = "unix://${config.services.redis.servers.paperless-ng.unixSocket}";
  });

  manage = let
    setupEnv = lib.concatStringsSep "\n" (mapAttrsToList (name: val: "export ${name}=\"${val}\"") env);
  in pkgs.writeShellScript "manage" ''
    ${setupEnv}
    exec ${cfg.package}/bin/paperless-ng "$@"
  '';

  # Secure the services
  defaultServiceConfig = {
    TemporaryFileSystem = "/:ro";
    BindReadOnlyPaths = [
      "/nix/store"
      "-/etc/resolv.conf"
      "-/etc/nsswitch.conf"
      "-/etc/hosts"
      "-/etc/localtime"
      "-/run/postgresql"
    ] ++ (optional (!hasCustomRedis) config.services.redis.servers.paperless-ng.unixSocket);
    BindPaths = [
      cfg.consumptionDir
      cfg.dataDir
      cfg.mediaDir
    ];
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
    ProcSubset = "pid";
    ProtectClock = true;
    # Breaks if the home dir of the user is in /home
    # Also does not add much value in combination with the TemporaryFileSystem.
    # ProtectHome = true;
    ProtectHostname = true;
    # Would re-mount paths ignored by temporary root
    #ProtectSystem = "strict";
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SupplementaryGroups = optional (!hasCustomRedis) config.services.redis.servers.paperless-ng.user;
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@privileged @resources @setuid @keyring" ];
    # Does not work well with the temporary root
    #UMask = "0066";
  };
in
{
  meta.maintainers = with maintainers; [ earvstedt Flakebi ];

  imports = [
    (mkRemovedOptionModule [ "services" "paperless"] ''
      The paperless module has been removed as the upstream project died.
      Users should migrate to the paperless-ng module (services.paperless-ng).
      More information can be found in the NixOS 21.11 release notes.
    '')
  ];

  options.services.paperless-ng = {
    enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Paperless-ng.

        When started, the Paperless database is automatically created if it doesn't
        exist and updated if the Paperless package has changed.
        Both tasks are achieved by running a Django migration.

        A script to manage the Paperless instance (by wrapping Django's manage.py) is linked to
        <literal>''${dataDir}/paperless-ng-manage</literal>.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/paperless";
      description = "Directory to store the Paperless data.";
    };

    mediaDir = mkOption {
      type = types.str;
      default = "${cfg.dataDir}/media";
      defaultText = literalExpression ''"''${dataDir}/media"'';
      description = "Directory to store the Paperless documents.";
    };

    consumptionDir = mkOption {
      type = types.str;
      default = "${cfg.dataDir}/consume";
      defaultText = literalExpression ''"''${dataDir}/consume"'';
      description = "Directory from which new documents are imported.";
    };

    consumptionDirIsPublic = mkOption {
      type = types.bool;
      default = false;
      description = "Whether all users can write to the consumption dir.";
    };

    passwordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/keys/paperless-ng-password";
      description = ''
        A file containing the superuser password.

        A superuser is required to access the web interface.
        If unset, you can create a superuser manually by running
        <literal>''${dataDir}/paperless-ng-manage createsuperuser</literal>.

        The default superuser name is <literal>admin</literal>. To change it, set
        option <option>extraConfig.PAPERLESS_ADMIN_USER</option>.
        WARNING: When changing the superuser name after the initial setup, the old superuser
        will continue to exist.

        To disable login for the web interface, set the following:
        <literal>extraConfig.PAPERLESS_AUTO_LOGIN_USERNAME = "admin";</literal>.
        WARNING: Only use this on a trusted system without internet access to Paperless.
      '';
    };

    address = mkOption {
      type = types.str;
      default = "localhost";
      description = "Web interface address.";
    };

    port = mkOption {
      type = types.port;
      default = 28981;
      description = "Web interface port.";
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Extra paperless-ng config options.

        See <link xlink:href="https://paperless-ng.readthedocs.io/en/latest/configuration.html">the documentation</link>
        for available options.
      '';
      example = literalExpression ''
        {
          PAPERLESS_OCR_LANGUAGE = "deu+eng";
        }
      '';
    };

    user = mkOption {
      type = types.str;
      default = defaultUser;
      description = "User under which Paperless runs.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.paperless-ng;
      defaultText = literalExpression "pkgs.paperless-ng";
      description = "The Paperless package to use.";
    };
  };

  config = mkIf cfg.enable {
    # Enable redis if no special url is set
    services.redis.servers.paperless-ng.enable = mkIf (!hasCustomRedis) true;

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
      "d '${cfg.mediaDir}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
      (if cfg.consumptionDirIsPublic then
        "d '${cfg.consumptionDir}' 777 - - - -"
      else
        "d '${cfg.consumptionDir}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
      )
    ];

    systemd.services.paperless-ng-server = {
      description = "Paperless document server";
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        ExecStart = "${cfg.package}/bin/paperless-ng qcluster";
        Restart = "on-failure";
      };
      environment = env;
      wantedBy = [ "multi-user.target" ];
      wants = [ "paperless-ng-consumer.service" "paperless-ng-web.service" ];

      preStart = ''
        ln -sf ${manage} ${cfg.dataDir}/paperless-ng-manage

        # Auto-migrate on first run or if the package has changed
        versionFile="${cfg.dataDir}/src-version"
        if [[ $(cat "$versionFile" 2>/dev/null) != ${cfg.package} ]]; then
          ${cfg.package}/bin/paperless-ng migrate
          echo ${cfg.package} > "$versionFile"
        fi
      ''
      + optionalString (cfg.passwordFile != null) ''
        export PAPERLESS_ADMIN_USER="''${PAPERLESS_ADMIN_USER:-admin}"
        export PAPERLESS_ADMIN_PASSWORD=$(cat "${cfg.dataDir}/superuser-password")
        superuserState="$PAPERLESS_ADMIN_USER:$PAPERLESS_ADMIN_PASSWORD"
        superuserStateFile="${cfg.dataDir}/superuser-state"

        if [[ $(cat "$superuserStateFile" 2>/dev/null) != $superuserState ]]; then
          ${cfg.package}/bin/paperless-ng manage_superuser
          echo "$superuserState" > "$superuserStateFile"
        fi
      '';
    } // optionalAttrs (!hasCustomRedis) {
      after = [ "redis-paperless-ng.service" ];
    };

    # Password copying can't be implemented as a privileged preStart script
    # in 'paperless-ng-server' because 'defaultServiceConfig' limits the filesystem
    # paths accessible by the service.
    systemd.services.paperless-ng-copy-password = mkIf (cfg.passwordFile != null) {
      requiredBy = [ "paperless-ng-server.service" ];
      before = [ "paperless-ng-server.service" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.coreutils}/bin/install --mode 600 --owner '${cfg.user}' --compare \
            '${cfg.passwordFile}' '${cfg.dataDir}/superuser-password'
        '';
        Type = "oneshot";
        # Needs to talk to mail server for automated import rules
        PrivateNetwork = false;
      };
    };

    systemd.services.paperless-ng-consumer = {
      description = "Paperless document consumer";
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        ExecStart = "${cfg.package}/bin/paperless-ng document_consumer";
        Restart = "on-failure";
      };
      environment = env;
      # Bind to `paperless-ng-server` so that the consumer never runs
      # during migrations
      bindsTo = [ "paperless-ng-server.service" ];
      after = [ "paperless-ng-server.service" ];
    };

    systemd.services.paperless-ng-web = {
      description = "Paperless web server";
      serviceConfig = defaultServiceConfig // {
        User = cfg.user;
        ExecStart = ''
          ${pkgs.python3Packages.gunicorn}/bin/gunicorn \
            -c ${cfg.package}/lib/paperless-ng/gunicorn.conf.py paperless.asgi:application
        '';
        Restart = "on-failure";

        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        # gunicorn needs setuid
        SystemCallFilter = defaultServiceConfig.SystemCallFilter ++ [ "@setuid" ];
        # Needs to serve web page
        PrivateNetwork = false;
      };
      environment = env // {
        PATH = mkForce cfg.package.path;
        PYTHONPATH = "${cfg.package.pythonPath}:${cfg.package}/lib/paperless-ng/src";
      };
      # Allow the web interface to access the private /tmp directory of the server.
      # This is required to support uploading files via the web interface.
      unitConfig.JoinsNamespaceOf = "paperless-ng-server.service";
      # Bind to `paperless-ng-server` so that the web server never runs
      # during migrations
      bindsTo = [ "paperless-ng-server.service" ];
      after = [ "paperless-ng-server.service" ];
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
