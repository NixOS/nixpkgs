{ config, lib, pkgs, ... }:
let
  cfg = config.services.samba-wsdd2;
  repeatFlag = flag: level:
    lib.concatStrings (builtins.genList (_: flag) level);
  args = lib.concatStringsSep " " ([
    (lib.optionalString cfg.ipv4Only "-4")
    (lib.optionalString cfg.ipv6Only "-6")
    (lib.optionalString cfg.udpOnly "-u")
    (lib.optionalString cfg.tcpOnly "-t")
    (lib.optionalString cfg.llmnrOnly "-l")
    (lib.optionalString cfg.wsddOnly "-w")
    (repeatFlag "-L" cfg.llmnrDebugLevel)
    (repeatFlag "-W" cfg.wsddDebugLevel)
    (lib.optionalString (cfg.interface != null) "-i ${cfg.interface}")
    (lib.optionalString (cfg.hostname != null) "-H ${cfg.hostname}")
    (lib.optionalString (cfg.aliases != null)
      ''-A "${lib.concatStringsSep "," cfg.aliases}"'')
    (lib.optionalString (cfg.netbiosName != null) "-N ${cfg.netbiosName}")
    (lib.optionalString (cfg.netbiosAliases != null)
      ''-B "${lib.concatStringsSep "," cfg.netbiosAliases}"'')
    (lib.optionalString (cfg.workgroup != null) "-G ${cfg.workgroup}")
    (lib.optionalString (cfg.bootParameters != null)
      ''-b "${cfg.bootParameters}"'')
  ]);
in {
  options.services.samba-wsdd2 = {
    enable = lib.mkEnableOption "Web Services Dynamic Discovery Daemon (wsdd2)";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open required firewall ports for WSDD2.";
    };
    ipv4Only = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run wsdd2 as a daemon.";
    };
    ipv6Only = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable IPv6-only mode.";
    };
    udpOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use UDP-only mode.";
    };
    tcpOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use TCP-only mode.";
    };
    llmnrOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable LLMNR-only mode.";
    };
    wsddOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable WSDD-only mode.";
    };
    llmnrDebugLevel = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Set LLMNR debug level (e.g., 1 = -L, 2 = -LL, etc.).";
    };
    wsddDebugLevel = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Set WSDD debug level (e.g., 1 = -W, 2 = -WW, etc.).";
    };
    interface = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Network interface to bind to (e.g., br0).";
    };
    hostname = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Set host name for WSDD.";
    };
    aliases = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = "Set host aliases.";
    };
    netbiosName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "NetBIOS name to advertise.";
    };
    netbiosAliases = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = "NetBIOS aliases.";
    };
    workgroup = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "HOME";
      description = "Set workgroup name.";
    };
    bootParameters = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Boot parameters in the format key1:val1,key2:val2,...";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.samba-wsdd2 = {
      description = "Web Services Dynamic Discovery Daemon (wsdd2)";
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.wsdd2}/bin/wsdd2 ${args}";
        Restart = "always";
        RestartSec = "5s";
        # Security Hardening Options
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = false;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies =
          [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RuntimeDirectoryMode = "0750";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@cpu-emulation"
          "~@debug"
          "~@mount"
          "~@obsolete"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0027";
      };
    };
    environment.systemPackages = [ pkgs.wsdd2 ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedUDPPorts = [ 3702 5355 ]; # WS-Discovery + LLMNR multicast UDP
      allowedTCPPorts = [ 5355 ]; # LLMNR unicast TCP
      extraCommands = ''
        ip6tables -A INPUT -p udp -m udp --dport 3702 -d ff02::c -j ACCEPT
        ip6tables -A INPUT -p udp -m udp --dport 5355 -d ff02::1:3 -j ACCEPT
      '';
    };
  };
}
