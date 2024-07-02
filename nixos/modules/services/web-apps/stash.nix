{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    ;

  cfg = config.services.stash;

  settingsFormat = pkgs.formats.yaml { };
in
{
  meta.maintainers = with lib; [ DrakeTDL ];
  options = {
    services.stash = {

      enable = mkEnableOption "stash";

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

      host = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "::1";
        description = "The ip address that the server should bind to.";
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

      libraryPaths = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = "List of read paths.";
      };

      # Stash errors on read-only config file
      # https://github.com/stashapp/stash/issues/5016
      # settings = mkOption {
      #   type = types.nullOr (types.submodule { freeformType = settingsFormat.type; });
      #   default = null;
      # };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.stash = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.ffmpeg ];
      environment = {
        STASH_HOST = cfg.host;
        STASH_PORT = toString cfg.port;
        # STASH_CONFIG_FILE =
        #   if cfg.settings != null then
        #     settingsFormat.generate "config.yml" cfg.settings
        #   else
        #     "%S/stash/config.yml";
        STASH_CONFIG_FILE = "%S/stash/config.yml";
        STASH_GENERATED = "%S/stash/generated";
        STASH_METADATA = "%S/stash/metadata";
        STASH_CACHE = "%C/stash/cache";
      };
      serviceConfig = {
        DynamicUser = true;
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        WorkingDirectory = "%S/stash";
        StateDirectory = [
          "stash"
          "stash/data"
          "stash/generated"
          "stash/metadata"
        ];
        CacheDirectory = "stash";
        ExecStart = lib.getExe cfg.package;

        ProtectHome = "tmpfs";
        BindReadOnlyPaths = map (path: "-${path}") cfg.libraryPaths;

        # hardening

        DevicePolicy = "auto"; # needed for hardware acceleration
        PrivateDevices = false; # needed for hardware acceleration
        AmbientCapabilities = [ "" ];
        CapabilityBoundingSet = [ "" ];
        ProtectSystem = "full";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProcSubset = "pid";
        ProtectProc = "invisible";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
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
  };
}
