{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kvrocks;

  format = pkgs.formats.keyValue {
    mkKeyValue =
      let
        mkValueString = v: if lib.isBool v then lib.boolToYesNo v else toString v;
      in
      k: v:
      if lib.isList v then
        lib.concatMapStringsSep "\n" (item: "${k} ${mkValueString item}") v
      else
        "${k} ${mkValueString v}";
  };

  configFile = format.generate "kvrocks.conf" (
    cfg.settings
    // {
      daemonize = "no";
      supervised = "systemd";
    }
  );
in
{
  meta.maintainers = pkgs.kvrocks.meta.maintainers;

  options = {
    services.kvrocks = {
      enable = lib.mkEnableOption "Kvrocks server";

      package = lib.mkPackageOption pkgs "kvrocks" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "kvrocks";
        description = "User account under which kvrocks runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "kvrocks";
        description = "Group under which kvrocks runs.";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;

          options = {
            bind = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1 ::1";
              description = "The address to bind to.";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 6666;
              description = "Accept connections on the specified port.";
            };

            dir = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/kvrocks";
              description = "The DB will be written inside this directory.";
            };
          };
        };
        default = { };
        description = ''
          Configuration for kvrocks.
          See <https://github.com/apache/kvrocks/blob/unstable/kvrocks.conf> for supported options.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open the firewall for the kvrocks port.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.port ];

    systemd.services.kvrocks = {
      description = "Kvrocks - Distributed key value database";
      documentation = [ "https://kvrocks.apache.org/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "notify";
        ExecStart = "${lib.getExe cfg.package} -c ${configFile}";
        Restart = "on-failure";
        RestartSec = "10s";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "kvrocks";
        RuntimeDirectory = "kvrocks";
        LimitNOFILE = 100000;
        LimitNPROC = 4096;
        TimeoutSec = 300;
        # Capabilities
        CapabilityBoundingSet = "";
        # Security
        NoNewPrivileges = true;
        # Sandboxing
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@cpu-emulation @debug @keyring @memlock @mount @obsolete @privileged @resources @setuid";
      };
    };

    users = {
      users = lib.mkIf (cfg.user == "kvrocks") {
        kvrocks = {
          isSystemUser = true;
          group = cfg.group;
          description = "Kvrocks daemon user";
        };
      };
      groups = lib.mkIf (cfg.group == "kvrocks") {
        kvrocks = { };
      };
    };
  };
}
