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
  meta.maintainers = with lib.maintainers; [ ];

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

    package = lib.mkPackageOption pkgs "tandoor-recipes" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.tandoor-recipes = {
      description = "Tandoor Recipes server";

      serviceConfig = {
        ExecStart = ''
          ${pkg.python.pkgs.gunicorn}/bin/gunicorn recipes.wsgi
        '';
        Restart = "on-failure";

        User = "tandoor_recipes";
        Group = "tandoor_recipes";
        DynamicUser = true;
        StateDirectory = "tandoor-recipes";
        WorkingDirectory = env.MEDIA_ROOT;
        RuntimeDirectory = "tandoor-recipes";

        BindReadOnlyPaths = [
          "${
            config.environment.etc."ssl/certs/ca-certificates.crt".source
          }:/etc/ssl/certs/ca-certificates.crt"
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
  };
}
