{ config, pkgs, lib, ... }:
let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkPackageOption
    mkIf
    ;

  cfg = config.services.glitchtip;
  pkg = cfg.package;

  env = {
    DEBUG = "0";
    DEBUG_TOOLBAR = "0";
  } // lib.optionalAttrs cfg.redis.createLocally {
    REDIS_URL = "redis+socket://${config.services.redis.servers.glitchtip.unixSocket}";
  } // {
    DATABASE_URL = "postgresql://@/glitchtip";
  } // cfg.extraConfig // {
    PYTHONPATH = "${pkgs.python311.pkgs.makePythonPath pkg.propagatedBuildInputs}:${pkg}/lib/glitchtip";
  };

  manage = pkgs.writeShellScript "manage" ''
    set -o allexport
    ${lib.toShellVars env}
    eval "$(${config.systemd.package}/bin/systemctl show -pUID,GID,MainPID tandoor-recipes.service)"
    exec ${pkgs.util-linux}/bin/nsenter \
      -t $MainPID -m -S $UID -G $GID \
      ${pkg}/bin/glitchtip "$@"
  '';

  gunicornArgs = builtins.concatStringsSep " " ([ "--bind=${cfg.address}:${toString cfg.port}" ] ++ cfg.gunicorn.extraArgs);

  celeryArgs = builtins.concatStringsSep " " cfg.celery.extraArgs;
in
{
  meta.maintainers = [ lib.maintainers.soyouzpanda ];

  options = {
    services.glitchtip = {
      enable = mkEnableOption "Glitchtip";
      package = mkPackageOption pkgs "glitchtip" { };

      user = mkOption {
        type = types.str;
        default = "glitchtip";
        description = "User account under which glitchtip runs.";
      };

      group = mkOption {
        type = types.str;
        default = "glitchtip";
        description = "Group under which glitchtip runs.";
      };

      address = mkOption {
        type = types.str;
        default = "localhost";
        description = "Web interface address.";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "Web interface port.";
      };

      extraPythonPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = "Extra python packages.";
      };

      gunicorn.extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Extra arguments for gunicorn";
      };

      celery.extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Extra arguments for celery";
      };

      database.createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to automatically set up the Postgresql instance.
        '';
      };

      redis.createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to automatically set up the Redis instance.
        '';
      };

      extraConfig = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = ''
          Environment variables used for Glitchtip.
        '';
      };

      extraConfigFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Path to file containing environment variables used for Glitchtip.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users = mkIf (cfg.user == "glitchtip") {
      glitchtip = {
        description = "Glithctip service";
        home = "/var/lib/glitchtip";
        group = cfg.group;
        extraGroups = lib.optionals cfg.redis.createLocally [ "redis-glitchtip" ];
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "glitchtip") {
      glitchtip = { };
    };

    services.redis.servers.glitchtip.enable = cfg.redis.createLocally;

    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "glitchtip" ];
      ensureUsers = [{
        name = "glitchtip";
        ensureDBOwnership = true;
      }];
    };

    systemd.services =
      let
        commonConfig = {
          User = cfg.user;
          Group = cfg.group;
          RuntimeDirectory = "glitchtip";
          StateDirectory = "glitchtip";
          EnvironmentFile = cfg.extraConfigFile;
          AmbientCapabilities = "";
          CapabilityBoundingSet = [ "" ];
          DevicePolicy = "closed";
          LockPersonality = true;
          NoNewPrivileges = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProcSubset = "pid";
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
        };
      in
      {
        glitchtip = {
          description = "Glitchtip";

          after = [ "network.target" "redis-glitchtip.service" "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];

          preStart = ''
            ln -sf ${manage} /var/lib/glitchtip/glitchtip-manage
            ${pkg}/bin/glitchtip migrate
          '';

          serviceConfig = {
            ExecStart = ''
              ${pkgs.python311.pkgs.gunicorn}/bin/gunicorn ${gunicornArgs} glitchtip.wsgi
            '';

            WorkingDirectory = "${pkg}/lib/glitchtip";
          } // commonConfig;

          environment = env;
        };

        glitchtip-worker = {
          description = "gltichtip job runnner";

          after = [ "network.target" "redis-glitchtip.service" "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.python311.pkgs.celery}/bin/celery -A glitchtip worker ${celeryArgs}";

            WorkingDirectory = "${pkg}/lib/glitchtip";
          } // commonConfig;

          environment = env;
        };
      };
  };
}
