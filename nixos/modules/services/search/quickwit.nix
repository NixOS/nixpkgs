{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.quickwit;

  settingsFormat = pkgs.formats.yaml {};
  quickwitYml = settingsFormat.generate "quickwit.yml" cfg.settings;

  usingDefaultDataDir = cfg.dataDir == "/var/lib/quickwit";
  usingDefaultUserAndGroup = cfg.user == "quickwit" && cfg.group == "quickwit";
in
{

  options.services.quickwit = {
    enable = mkEnableOption "Quickwit";

    package = lib.mkPackageOption pkgs "Quickwit" {
      default = [ "quickwit" ];
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options."rest" = lib.mkOption {
          default = {};
          description = ''
            Rest server configuration for Quickwit
          '';

          type = lib.types.submodule {
            freeformType = settingsFormat.type;

            options."listen_port" = lib.mkOption {
              type = lib.types.port;
              default = 7280;
              description = ''
                The port to listen on for HTTP REST traffic.
              '';
            };
          };
        };

        options."grpc_listen_port" = lib.mkOption {
          type = lib.types.port;
          default = 7281;
          description = ''
            The port to listen on for gRPC traffic.
          '';
        };

        options."listen_address" = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = ''
            Listen address of Quickwit.
          '';
        };

        options."version" = lib.mkOption {
          type = lib.types.float;
          default = 0.7;
          description = ''
            Configuration file version.
          '';
        };
      };

      default = {};

      description = ''
        Quickwit configuration.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/quickwit";
      apply = converge (removeSuffix "/");
      description = ''
        Data directory for Quickwit. If you change this, you need to
        manually create the directory. You also need to create the
        `quickwit` user and group, or change
        [](#opt-services.quickwit.user) and
        [](#opt-services.quickwit.group) to existing ones with
        access to the directory.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "quickwit";
      description = ''
        The user Quickwit runs as. Should be left at default unless
        you have very specific needs.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "quickwit";
      description = ''
        The group quickwit runs as. Should be left at default unless
        you have very specific needs.
      '';
    };

    extraFlags = lib.mkOption {
      description = "Extra command line options to pass to Quickwit.";
      default = [ ];
      type = lib.types.listOf lib.types.str;
    };

    restartIfChanged = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Automatically restart the service on config change.
        This can be set to false to defer restarts on a server or cluster.
        Please consider the security implications of inadvertently running an older version,
        and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
      '';
      default = true;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.quickwit = {
      description = "Quickwit";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      inherit (cfg) restartIfChanged;
      environment = {
        QW_DATA_DIR = cfg.dataDir;
      };
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/quickwit run --config ${quickwitYml} \
          ${escapeShellArgs cfg.extraFlags}
        '';
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        DynamicUser = usingDefaultUserAndGroup && usingDefaultDataDir;
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = [
          cfg.dataDir
        ];
        RestrictAddressFamilies = [
          "AF_NETLINK"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          # 1. allow a reasonable set of syscalls
          "@system-service @resources"
          # 2. and deny unreasonable ones
          "~@privileged"
          # 3. then allow the required subset within denied groups
          "@chown"
        ];
      } // (optionalAttrs (usingDefaultDataDir) {
        StateDirectory = "quickwit";
        StateDirectoryMode = "0700";
      });
    };

    environment.systemPackages = [ cfg.package ];
  };
}
