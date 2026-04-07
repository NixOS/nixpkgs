{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.kanbn;

  # Build the environment passed to both the migrate and web units. Only
  # variables that are non-null are forwarded; everything else is left to
  # the (optional) environmentFile so secrets can be kept out of the store.
  baseEnv = {
    PORT = toString cfg.port;
    HOSTNAME = cfg.host;
    NODE_ENV = "production";
    NEXT_PUBLIC_BASE_URL = cfg.baseUrl;
  }
  // lib.optionalAttrs (cfg.database.url != null) {
    POSTGRES_URL = cfg.database.url;
  }
  // cfg.extraEnvironment;

  environmentFiles = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
in
{
  options.services.kanbn = {
    enable = lib.mkEnableOption "kanbn, an open source Trello/Jira alternative";

    package = lib.mkPackageOption pkgs "kanbn" { };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address the kanbn web server should bind to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "TCP port the kanbn web server should listen on.";
    };

    baseUrl = lib.mkOption {
      type = lib.types.str;
      example = "https://kanbn.example.com";
      description = ''
        Public base URL kanbn is reachable at. Forwarded as
        `NEXT_PUBLIC_BASE_URL`.
      '';
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to provision a local PostgreSQL database and user for
          kanbn. When enabled, {option}`services.kanbn.database.url` is
          set automatically to a unix-socket connection string.
        '';
      };

      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "postgres://kanbn@localhost/kanbn";
        description = ''
          PostgreSQL connection URL passed as `POSTGRES_URL`. If null and
          {option}`createLocally` is true, a unix-socket URL is generated
          automatically. For secret credentials prefer
          {option}`environmentFile`.
        '';
      };
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/kanbn.env";
      description = ''
        Path to an EnvironmentFile read by both kanbn services. Use this
        to provide secrets such as `BETTER_AUTH_SECRET`, OAuth client
        credentials or `POSTGRES_URL` without putting them into the
        Nix store.
      '';
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = lib.literalExpression ''
        {
          NEXT_PUBLIC_DISABLE_SIGN_UP = "true";
          LOG_LEVEL = "info";
        }
      '';
      description = ''
        Extra environment variables passed to the kanbn services. See the
        upstream documentation and `docker-compose.yml` for the full list
        of supported variables.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "kanbn";
      description = "User the kanbn services run as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "kanbn";
      description = "Group the kanbn services run as.";
    };
  };

  config = lib.mkIf cfg.enable {
    # When createLocally is on, default POSTGRES_URL to a peer-auth socket
    # connection (only if the user did not set one explicitly).
    services.kanbn.database.url = lib.mkIf cfg.database.createLocally (
      lib.mkDefault "postgres://${cfg.user}@localhost/kanbn?host=/run/postgresql"
    );

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "kanbn" ];
      ensureUsers = [
        {
          name = cfg.user;
          ensureDBOwnership = true;
        }
      ];
    };

    users.users.${cfg.user} = lib.mkIf (cfg.user == "kanbn") {
      isSystemUser = true;
      group = cfg.group;
      description = "kanbn service user";
    };
    users.groups.${cfg.group} = lib.mkIf (cfg.group == "kanbn") { };

    systemd.services.kanbn-migrate = {
      description = "kanbn database migrations";
      wantedBy = [ "multi-user.target" ];
      before = [ "kanbn.service" ];
      after = lib.optional cfg.database.createLocally "postgresql.target";
      requires = lib.optional cfg.database.createLocally "postgresql.target";
      environment = baseEnv // {
        # drizzle-kit tries to create ~/.local/share/drizzle-studio.
        HOME = "/tmp";
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = environmentFiles;
        ExecStart = "${cfg.package}/bin/kanbn-migrate";
        PrivateTmp = true;
      };
    };

    systemd.services.kanbn = {
      description = "kanbn web server";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "kanbn-migrate.service"
      ]
      ++ lib.optional cfg.database.createLocally "postgresql.target";
      requires = [ "kanbn-migrate.service" ];
      environment = baseEnv;
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = environmentFiles;
        # bootstrap.cjs writes apps/web/public/__ENV.js at startup with the
        # current NEXT_PUBLIC_* values, so the web tree must be writable.
        # Copy the read-only store tree into RuntimeDirectory before starting.
        ExecStartPre = "${pkgs.coreutils}/bin/cp -a --no-preserve=mode,ownership ${cfg.package}/lib/kanbn/web/. /run/kanbn/";
        ExecStart = "${lib.getExe pkgs.nodejs_20} /run/kanbn/bootstrap.cjs";
        Restart = "on-failure";
        RestartSec = 5;

        RuntimeDirectory = "kanbn";
        RuntimeDirectoryMode = "0750";
        StateDirectory = "kanbn";
        WorkingDirectory = "/run/kanbn";

        # Hardening
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ mkg20001 ];
}
