{ config, lib, pkgs, ... }:
let
  cfg = config.services.samba-wsdd;

in {
  options = {
    services.samba-wsdd = {
      enable = lib.mkEnableOption ''
        Web Services Dynamic Discovery host daemon. This enables (Samba) hosts, like your local NAS device,
        to be found by Web Service Discovery Clients like Windows
      '';
      interface = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "eth0";
        description = "Interface or address to use.";
      };
      hoplimit = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 2;
        description = "Hop limit for multicast packets (default = 1).";
      };
      openFirewall = lib.mkOption {
        description = ''
          Whether to open the required firewall ports in the firewall.
        '';
        default = false;
        type = lib.types.bool;
      };
      workgroup = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "HOME";
        description = "Set workgroup name (default WORKGROUP).";
      };
      hostname = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "FILESERVER";
        description = "Override (NetBIOS) hostname to be used (default hostname).";
      };
      domain = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Set domain name (disables workgroup).";
      };
      discovery = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable discovery operation mode.";
      };
      listen = lib.mkOption {
        type = lib.types.str;
        default = "/run/wsdd/wsdd.sock";
        description = "Listen on path or localhost port in discovery mode.";
      };
      extraOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "--shortlog" ];
        example = [ "--verbose" "--no-http" "--ipv4only" "--no-host" ];
        description = "Additional wsdd options.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.wsdd ];

    systemd.services.samba-wsdd = {
      description = "Web Services Dynamic Discovery host daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        Type = "simple";
        ExecStart = ''
          ${pkgs.wsdd}/bin/wsdd ${lib.optionalString (cfg.interface != null) "--interface '${cfg.interface}'"} \
                                ${lib.optionalString (cfg.hoplimit != null) "--hoplimit '${toString cfg.hoplimit}'"} \
                                ${lib.optionalString (cfg.workgroup != null) "--workgroup '${cfg.workgroup}'"} \
                                ${lib.optionalString (cfg.hostname != null) "--hostname '${cfg.hostname}'"} \
                                ${lib.optionalString (cfg.domain != null) "--domain '${cfg.domain}'"} \
                                ${lib.optionalString cfg.discovery "--discovery --listen '${cfg.listen}'"} \
                                ${lib.escapeShellArgs cfg.extraOptions}
        '';
        # Runtime directory and mode
        RuntimeDirectory = "wsdd";
        RuntimeDirectoryMode = "0750";
        # Access write directories
        UMask = "0027";
        # Capabilities
        CapabilityBoundingSet = "";
        # Security
        NoNewPrivileges = true;
        # Sandboxing
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = false;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@cpu-emulation @debug @mount @obsolete @privileged @resources";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 5357 ];
      allowedUDPPorts = [ 3702 ];
    };
  };
}
