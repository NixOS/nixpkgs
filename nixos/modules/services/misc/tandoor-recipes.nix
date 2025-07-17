{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.tandoor-recipes;
  pkg = cfg.package;

  # SECRET_KEY through an env file
  env =
    {
      GUNICORN_CMD_ARGS = "--bind=${cfg.address}:${toString cfg.port}";
      DEBUG = "0";
      DEBUG_TOOLBAR = "0";
      MEDIA_ROOT = "/var/lib/tandoor-recipes";
    }
    // lib.optionalAttrs (config.time.timeZone != null) {
      TZ = config.time.timeZone;
    }
    // (lib.mapAttrs (_: toString) cfg.extraConfig);

  manage = pkgs.writeShellScript "manage" ''
    set -o allexport # Export the following env vars
    ${lib.toShellVars env}
    eval "$(${config.systemd.package}/bin/systemctl show -pUID,GID,MainPID tandoor-recipes.service)"
    exec ${pkgs.util-linux}/bin/nsenter \
      -t $MainPID -m -S $UID -G $GID --wdns=${env.MEDIA_ROOT} \
      ${pkg}/bin/tandoor-recipes "$@"
  '';
in
{
  meta.maintainers = with lib.maintainers; [ jvanbruegge ];

  options.services.tandoor-recipes = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Tandoor Recipes.

        When started, the Tandoor Recipes database is automatically created if
        it doesn't exist and updated if the package has changed. Both tasks are
        achieved by running a Django migration.

        A script to manage the instance (by wrapping Django's manage.py) is linked to
        `/var/lib/tandoor-recipes/tandoor-recipes-manage`.
      '';
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Web interface address.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Web interface port.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Extra tandoor recipes config options.

        See [the example dot-env file](https://raw.githubusercontent.com/vabene1111/recipes/master/.env.template)
        for available options.
      '';
      example = {
        ENABLE_SIGNUP = "1";
      };
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "tandoor_recipes";
      description = "User account under which Tandoor runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "tandoor_recipes";
      description = "Group under which Tandoor runs.";
    };

    package = lib.mkPackageOption pkgs "tandoor-recipes" { };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Configure local PostgreSQL database server for Tandoor Recipes.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.mkIf (cfg.user == "tandoor_recipes") {
      tandoor_recipes = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "tandoor_recipes") {
      tandoor_recipes = { };
    };

    systemd.services.tandoor-recipes = {
      description = "Tandoor Recipes server";

      requires = lib.optional cfg.database.createLocally "postgresql.target";
      after = lib.optional cfg.database.createLocally "postgresql.target";

      serviceConfig = {
        ExecStart = ''
          ${pkg.python.pkgs.gunicorn}/bin/gunicorn recipes.wsgi
        '';
        Restart = "on-failure";

        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "tandoor-recipes";
        WorkingDirectory = env.MEDIA_ROOT;
        RuntimeDirectory = "tandoor-recipes";

        BindReadOnlyPaths = [
          "${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt"
          builtins.storeDir
          "-/etc/resolv.conf"
          "-/etc/nsswitch.conf"
          "-/etc/hosts"
          "-/etc/localtime"
          "-/run/postgresql"
        ];
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        # gunicorn needs setuid
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "@resources"
          "@setuid"
          "@keyring"
        ];
        UMask = "0066";
      };

      wantedBy = [ "multi-user.target" ];

      preStart = ''
        ln -sf ${manage} tandoor-recipes-manage

        # Let django migrate the DB as needed
        ${pkg}/bin/tandoor-recipes migrate
      '';

      environment = env // {
        PYTHONPATH = "${pkg.python.pkgs.makePythonPath pkg.propagatedBuildInputs}:${pkg}/lib/tandoor-recipes";
      };
    };

    services.paperless.settings = lib.mkIf cfg.database.createLocally {
      DB_ENGINE = "django.db.backends.postgresql";
      POSTGRES_HOST = "/run/postgresql";
      POSTGRES_USER = "tandoor_recipes";
      POSTGRES_DB = "tandoor_recipes";
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "tandoor_recipes" ];
      ensureUsers = [
        {
          name = "tandoor_recipes";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
