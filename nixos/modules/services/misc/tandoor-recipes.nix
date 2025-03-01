{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.tandoor-recipes;
  pkg = cfg.package;
  stateDir = "/var/lib/tandoor-recipes";
  mediaRoot =
    if lib.versionAtLeast config.system.stateVersion "25.05" then
      "${stateDir}/media"
    else if cfg.extraConfig ? MEDIA_ROOT then
      cfg.extraConfig.MEDIA_ROOT
    else
      lib.warn ''
        Starting at NixOS 25.05 the default MEDIA_ROOT will be set to
        /var/lib/tandoor-recipes/media instead of /var/lib/tandoor-recipes. For
        more info see https://github.com/NixOS/nixpkgs/pull/386167.
      '' stateDir;

  # SECRET_KEY through an env file
  env =
    {
      GUNICORN_CMD_ARGS = "--bind=${cfg.address}:${toString cfg.port}";
      DEBUG = "0";
      DEBUG_TOOLBAR = "0";
      MEDIA_ROOT = mediaRoot;
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
      -t $MainPID -m -S $UID -G $GID --wdns=${stateDir} \
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

        See [the tandoor documentation](https://docs.tandoor.dev/system/configuration)
        for all available options. And the [environment template](https://raw.githubusercontent.com/vabene1111/recipes/master/.env.template)
        for a commonly used subset.

        By default the following environment will be used:

        ```nix
        {
          GUNICORN_CMD_ARGS = "--bind=''${cfg.address}:''${toString cfg.port}";
          DEBUG = "0";
          DEBUG_TOOLBAR = "0";
          MEDIA_ROOT = /var/lib/tandoor-recipes/media;
        }
        // lib.optionalAttrs (config.time.timeZone != null) {
          TZ = config.time.timeZone;
        }
        ```

        Any environment variables set through this option are combined with the
        default environment. If the variable is already part of the default
        environment it will override the default.
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

      serviceConfig = {
        ExecStart = ''
          ${pkg.python.pkgs.gunicorn}/bin/gunicorn recipes.wsgi
        '';
        Restart = "on-failure";

        User = cfg.user;
        Group = cfg.group;
        StateDirectory = [
          "tandoor-recipes"
        ] ++ lib.optional (env.MEDIA_ROOT == "/var/lib/tandoor-recipes/media") "tandoor-recipes/media";
        WorkingDirectory = stateDir;
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
  };
}
