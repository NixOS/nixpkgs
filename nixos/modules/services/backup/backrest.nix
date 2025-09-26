{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.backrest;
in
{
  options.services.backrest = with lib; {
    enable = mkEnableOption "Backrest Web UI";
    package = mkPackageOption pkgs "backrest" { };
    openFirewall = mkEnableOption "opening the ports in the firewall";
    user = mkOption {
      type = types.str;
      description = "The user to run Backrest as";
      default = "backrest";
    };
    group = mkOption {
      type = types.str;
      description = "The group to run Backrest as";
      default = "backrest";
    };
    listen = mkOption {
      type = types.submodule {
        options = {
          host = mkOption {
            type = types.str;
            description = "The host to listen to";
            default = "127.0.0.1";
          };
          port = mkOption {
            type = types.port;
            description = "The port to listen to";
            default = 9898;
          };
        };
      };
      description = "Listen options";
      default = { };
    };
    resticBinary = mkPackageOption pkgs "restic" { };
    additionalPaths = mkOption {
      type = types.listOf types.path;
      description = "Packages to add to the PATH of the unit file. Useful to make packages available to hooks. See https://garethgeorge.github.io/backrest/cookbooks/command-hook-examples for examples";
      default = [ ];
    };
    rootDirectory = mkOption {
      type = types.str;
      description = "The main Backrest root directory";
      default = "/var/lib/backrest";
    };
    configPath = mkOption {
      type = types.oneOf [
        types.str
        types.path
      ];
      description = "The path of the Backrest config file";
      default = "${cfg.rootDirectory}/config.json";
      defaultText = "\"\${cfg.rootDirectory}/config.json\"";
    };
    dataDirectory = mkOption {
      type = types.str;
      description = "The path of the Backrest data directory. This is not to be confused with the target repository location.";
      default = "${cfg.rootDirectory}/data";
      defaultText = "\"\${cfg.rootDirectory}/data\"";
    };
    cacheDirectory = mkOption {
      type = types.str;
      description = "The path of the Backrest cache directory";
      default = "${cfg.rootDirectory}/cache";
      defaultText = "\"\${cfg.rootDirectory}/cache\"";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      cfg.resticBinary
    ];

    users.users.${cfg.user} = {
      description = lib.mkDefault "Backrest service user";
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.${cfg.group} = { };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.listen.port
    ];

    systemd.tmpfiles.settings = {
      "10-backrest" = {
        "${cfg.rootDirectory}" = {
          d = {
            user = cfg.user;
            group = cfg.group;
            mode = "0750";
            age = "-";
          };
        };
        "${cfg.cacheDirectory}" = {
          d = {
            user = cfg.user;
            group = cfg.group;
            mode = "0750";
            age = "-";
          };
        };
        "${cfg.dataDirectory}" = {
          d = {
            user = cfg.user;
            group = cfg.group;
            mode = "0750";
            age = "-";
          };
        };
      };
    };

    systemd.services.backrest = {
      description = "Web-accessible backup solution built on top of restic.";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = cfg.additionalPaths;
      environment = {
        BACKREST_PORT = "${cfg.listen.host}:${toString cfg.listen.port}";
        BACKREST_CONFIG = cfg.configPath;
        BACKREST_DATA = cfg.dataDirectory;
        BACKREST_RESTIC_COMMAND = lib.getExe' cfg.resticBinary "restic";
        XDG_CACHE_HOME = cfg.cacheDirectory;
      };
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        RestartSec = 60;
        NoNewPrivileges = true;
        LockPersonality = true;
        UMask = "0077";
        SystemCallFilter = [
          " " # This is needed to clear the SystemCallFilter existing definitions
          "~@reboot"
          "~@swap"
          "~@obsolete"
          "~@mount"
          "~@module"
          "~@debug"
          "~@cpu-emulation"
          "~@clock"
          "~@raw-io"
          "~@privileged"
          "~@resources"
        ];
        AmbientCapabilities = [
          "CAP_DAC_READ_SEARCH"
        ];
        CapabilityBoundingSet = [
          "CAP_DAC_READ_SEARCH"
        ];
        RestrictAddressFamilies = [
          " " # This is needed to clear the RestrictAddressFamilies existing definitions
          "none" # Remove all addresses families
          "AF_INET"
          "AF_INET6"
        ];
        DevicePolicy = "closed";
        ProtectKernelLogs = true;
        SystemCallArchitectures = "native";
        RestrictSUIDSGID = true;
        ExecStart = [
          "${lib.getExe' cfg.package "backrest"}"
        ];
      };
    };
  };
  meta = {
    maintainers = with lib.maintainers; [
      m0ustach3
    ];
  };
}
