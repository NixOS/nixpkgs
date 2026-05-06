{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;
  inherit (lib.types)
    addCheck
    either
    enum
    ints
    path
    port
    str
    ;
  inherit (builtins) stringLength;
  token = addCheck str (s: stringLength s == 32);
  cfg = config.services.fmd-server;
  config-file = pkgs.writeText "config.yml" ''
    DatabaseDir: "${cfg.databaseDir}"
    PortInsecure: ${toString cfg.port}
    PortSecure: -1
    RegistrationToken: "${cfg.registration-token}"
    RemoteIpHeader: "X-Real-IP"
    UserIdLength: ${toString cfg.user-id-length}
    MaxSavedLoc: ${toString cfg.max-saved-loc}
    MaxSavedPic: ${toString cfg.max-saved-pic}
    ${
      if cfg.prometheus.enable then
        ''MetricsAddrPort: "${cfg.prometheus.address}:${toString cfg.prometheus.port}"''
      else
        ""
    }
  '';
in
{
  options = {
    services.fmd-server = {
      enable = mkEnableOption "Find My Device server";
      package = mkPackageOption pkgs "fmd-server" { };

      user = mkOption {
        type = str;
        default = "fmd";
        description = "User account under which fmd-server runs.";
      };

      group = mkOption {
        type = str;
        default = "fmd";
        description = "Group under which fmd-server runs";
      };

      dataDir = mkOption {
        type = path;
        default = "/var/lib/fmd-server";
        description = "Base path directory";
      };

      databaseDir = mkOption {
        type = path;
        # This is more convoluted that it might seem necessary, but this is to ensure that the
        # manual builds.  Indeed, when the manual is built, the `config` set doesn't contain a
        # `services` attribute.
        default = "${config.services.fmd-server.dataDir or "/var/lib/fmd-server"}/db";
        description = "Base database directory";
      };

      port = mkOption {
        type = port;
        default = 7893;
        description = "Port for the web interface";
      };

      user-id-length = mkOption {
        type = ints.positive;
        default = 5;
        description = "The length for the user IDs that are generated.";
      };

      max-saved-loc = mkOption {
        type = ints.positive;
        default = 500;
        description = "How many location points FMD server should save per account.";
      };

      max-saved-pic = mkOption {
        type = ints.positive;
        default = 10;
        description = "How many pictures FMD server should save per account";
      };

      registration-token = mkOption {
        type = either (enum [ "public" ]) token;
        description = "A token required to connect to this instance.  Can be set to `public` if no token is required, or to a 32 character string that should be shared only with applications that are allowed to connect.";
      };

      prometheus = {
        enable = mkEnableOption "Run Prometheus metrics on FMD server.";
        address = mkOption {
          type = str;
          example = "[::1]";
          description = "The address of the Prometheus server.";
        };
        port = mkOption {
          type = port;
          # See the comment on `databaseDir.default` on why it is needed to have a default value
          # for `config.services.prometheus.enable`.
          default =
            if config.services.prometheus.enable or false then config.services.prometheus.port else 9090;
          description = "The port the Prometheus server is listening to";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      tmpfiles.settings.fmd-dirs =
        let
          dir = {
            inherit (cfg) user group;
            mode = "700";
          };
        in
        {
          "${cfg.dataDir}"."d" = dir;
          "${cfg.databaseDir}"."d" = dir;
        };
      services.fmd-server = {
        enable = true;
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        description = "Find My Device server";
        serviceConfig = {
          # Follows https://fmd-foss.org/docs/fmd-server/installation/linux/#step-6-manage-with-systemd
          ExecStart = "${getExe cfg.package} serve --db-dir '${cfg.databaseDir}' --config '${config-file}'";
          Type = "simple";
          Restart = "always";
          User = cfg.user;
          Group = cfg.group;

          ProtectProc = "invisible";
          NoNewPrivileges = true;
          CapabilityBoundingSet = [ "" ];
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          RuntimeDirectory = "fmd-server";
          ReadWritePaths = [
            cfg.dataDir
            cfg.databaseDir
          ];
          SystemCallFilter = "@system-service";
          SystemCallArchitectures = "native";
          WorkingDirectory = cfg.dataDir;
        };
      };
    };

    users.users = mkIf (cfg.user == "fmd") {
      fmd = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "fmd") {
      fmd = { };
    };
  };
}
