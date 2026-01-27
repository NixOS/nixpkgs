{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.netfoil;
in
{
  options = {
    services.netfoil = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Netfoil, a minimal, filtering, DNS proxy";
      };
      listen = {
        port = lib.mkOption {
          type = lib.types.int;
          default = 53;
          description = "Port on which Netfoil listens for incoming connections";
        };
        ipAddress = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "IP address on which Netfoil listens for incoming connections";
        };
      };
      logAllowed = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Log allowed DNS queries";
      };
      doHUrl = lib.mkOption {
        type = lib.types.str;
        default = "https://security.cloudflare-dns.com/dns-query";
        description = "The DoH URL to use for upstream DNS queries";
      };
      doHIPs = lib.mkOption {
        type = lib.types.str;
        default = "1.1.1.2,1.0.0.2";
        description = "The DoH IPs to use for upstream DNS queries";
      };
      logDenied = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Log denied DNS queries";
      };
      config = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Additional configuration options for Netfoil";
      };
      rules = {
        allow = {
          exact = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of exact domain names to allow";
          };
          ipv4 = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of ipv4 CIDR ranges to allow";
          };
          ipv6 = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of ipv6 CIDR ranges to allow";
          };
          tld = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of TLDs to allow";
          };
        };
        deny = {
          exact = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of exact domain names to deny";
          };
          ipv4 = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of ipv4 CIDR ranges to deny";
          };
          ipv6 = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of ipv6 CIDR ranges to deny";
          };
          tld = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of TLDs to deny";
          };
        };
        known = {
          knownTlds = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              ".com"
              ".net"
              ".org"
              ".edu"
              ".gov"
              ".mil"
              ".int"
            ];
            description = "List of known TLDs";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    let
      configFile = lib.concatStringsSep "\n" (
        [
          "LogAllowed=${lib.boolToString cfg.logAllowed}"
          "LogDenied=${lib.boolToString cfg.logDenied}"
          "DoHURL=${cfg.doHUrl}"
          "DoHIPs=${cfg.doHIPs}"
        ]
        ++ (map (key: "${key} = \"${cfg.config.${key}}\"") (lib.attrNames cfg.config))
      );
      configDir = pkgs.buildEnv {
        name = "netfoil-config";
        paths = [
          (pkgs.writeTextDir "config" configFile)
          (pkgs.writeTextDir "allow.exact" (lib.concatStringsSep "\n" cfg.rules.allow.exact))
          (pkgs.writeTextDir "allow.ipv4" (lib.concatStringsSep "\n" cfg.rules.allow.ipv4))
          (pkgs.writeTextDir "allow.ipv6" (lib.concatStringsSep "\n" cfg.rules.allow.ipv6))
          (pkgs.writeTextDir "allow.suffix" (lib.concatStringsSep "\n" cfg.rules.allow.tld))
          (pkgs.writeTextDir "allow.tld" (lib.concatStringsSep "\n" cfg.rules.allow.tld))
          (pkgs.writeTextDir "deny.exact" (lib.concatStringsSep "\n" cfg.rules.deny.exact))
          (pkgs.writeTextDir "deny.ipv4" (lib.concatStringsSep "\n" cfg.rules.deny.ipv4))
          (pkgs.writeTextDir "deny.ipv6" (lib.concatStringsSep "\n" cfg.rules.deny.ipv6))
          (pkgs.writeTextDir "deny.suffix" (lib.concatStringsSep "\n" cfg.rules.deny.tld))
          (pkgs.writeTextDir "deny.tld" (lib.concatStringsSep "\n" cfg.rules.deny.tld))
          (pkgs.writeTextDir "known.tld" (lib.concatStringsSep "\n" cfg.rules.known.knownTlds))
        ];
      };
    in
    {
      systemd = {
        services.netfoil = {
          enable = true;
          description = "Netfoil DNS proxy";
          after = [ "network.target" ];
          requires = [ "netfoil.socket" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.netfoil}/bin/netfoil --config-directory ${configDir}";
            Restart = "always";
            RestartSec = "5";
            DynamicUser = true;
            BindReadOnlyPaths = [
              "${pkgs.netfoil}"
              "${configDir}"
              "/etc/ssl"
              builtins.storeDir
            ];
            Slice = "netfoil.slice";
            AmbientCapabilities = "";
            CapabilityBoundingSet = [ ];
            SystenCallArchitectures = "native";
            SystemCallFilter = [
              "@basic-io"
              "@file-system"
              "@network-io"
              "@signal"
              "@process"
              "@io-event"
              "@system-service"
              "@resources"
            ];
            RuntimeDirectory = "netfoil";
            RuntimeDirectoryMode = "0755";
            RootDirectory = "/run/netfoil";
            RestrictAddressFamilies = "AF_INET AF_INET6";
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;

            # This might set AllowDevices=char-rtc r
            ProtectClock = true;

            ProtectKernelModules = true;
            ProtectKernelLogs = true;

            LockPersonality = true;
            MemoryDenyWriteExecute = true;

            RemoveIPC = true;
            UMask = "0077";

            # IPC namespace
            PrivateIPC = true;

            # UTS namespace
            ProtectHostname = true;

            # Changes mounts (custom is more strict)
            # https://github.com/systemd/systemd/blob/main/src/core/namespace.c
            #
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectProc = "invisible";
            ProcSubset = "pid";
            ProtectSystem = "strict";
            PrivateTmp = true;

            #
            # seccomp _sysctl (custom filter does not allow it anyway)
            # /proc and /sys mounts (custom is more strict)
            ProtectKernelTunables = true;
            #
            # seccomp @raw-io (custom filter does not allow it anyway)
            PrivateDevices = true;
            DevicePolicy = "closed";

            SocketBindDeny = "any";

            CPUQuota = "50%";
            MemoryMax = "100M";
            TasksMax = "100";
          };
        };
        slices.netfoil = {
          description = "Slice for Netfoil DNS proxy";
        };
        sockets.netfoil = {
          description = "Netfoil DNS proxy socket";
          wantedBy = [ "sockets.target" ];
          socketConfig = {
            ListenDatagram = "${cfg.listen.ipAddress}:${toString cfg.listen.port}";
            Service = "netfoil.service";
          };
        };
      };
    }
  );
}
