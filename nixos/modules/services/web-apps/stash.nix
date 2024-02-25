{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkPackageOption mkOption types mkIf;
  cfg = config.services.stash;
in
{
  options = {
    services.stash = {
      enable = mkEnableOption "an organizer for your porn, written in Go";

      package = mkPackageOption pkgs "stash" { };

      user = mkOption {
        type = types.str;
        default = "stash";
        description = "User account under which stash runs.";
      };

      group = mkOption {
        type = types.str;
        default = "stash";
        description = "Group under which stash runs.";
      };

      ip = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "::1";
        description = "The ip that the server should bind to.";
      };

      port = mkOption {
        type = types.port;
        default = 9999;
        description = "The port that the server should listen on.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the stash web interface.";
      };

      readWritePaths = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = "List of read and write paths.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.stash = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        STASH_HOST = cfg.ip;
        STASH_PORT = toString cfg.port;
        STASH_GENERATED = "%S/stash/generated";
        STASH_METADATA = "%S/stash/metadata";
        STASH_CACHE = "%S/stash/cache";
      };
      preStart = ''mkdir -p -- "$STASH_GENERATED" "$STASH_METADATA" "$STASH_CACHE"'';
      serviceConfig = {
        DynamicUser = true;
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        StateDirectory = "stash";
        WorkingDirectory = "%S/stash";
        ExecStart = lib.getExe cfg.package;

        ReadWritePaths = cfg.readWritePaths;

        AmbientCapabilities = [ "" ];
        CapabilityBoundingSet = [ "" ];
        ProtectSystem = "full";
        LockPersonality = true;
        NoNewPrivileges = true;
        DevicePolicy = "auto"; # needed for hardware acceleration
        PrivateDevices = false; # needed for hardware acceleration
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProcSubset = "pid";
        ProtectProc = "invisible";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@cpu-emulation"
          "~@debug"
          "~@mount"
          "~@obsolete"
          "~@privileged"
        ];
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
