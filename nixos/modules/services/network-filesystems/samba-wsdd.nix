{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.samba-wsdd;

in {
  options = {
    services.samba-wsdd = {
      enable = mkEnableOption ''
        Enable Web Services Dynamic Discovery host daemon. This enables (Samba) hosts, like your local NAS device,
        to be found by Web Service Discovery Clients like Windows.
        <note>
          <para>If you use the firewall consider adding the following:</para>
          <programlisting>
            networking.firewall.allowedTCPPorts = [ 5357 ];
            networking.firewall.allowedUDPPorts = [ 3702 ];
          </programlisting>
        </note>
      '';
      interface = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "eth0";
        description = lib.mdDoc "Interface or address to use.";
      };
      hoplimit = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 2;
        description = lib.mdDoc "Hop limit for multicast packets (default = 1).";
      };
      workgroup = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "HOME";
        description = lib.mdDoc "Set workgroup name (default WORKGROUP).";
      };
      hostname = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "FILESERVER";
        description = lib.mdDoc "Override (NetBIOS) hostname to be used (default hostname).";
      };
      domain = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc "Set domain name (disables workgroup).";
      };
      discovery = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Enable discovery operation mode.";
      };
      listen = mkOption {
        type = types.str;
        default = "/run/wsdd/wsdd.sock";
        description = lib.mdDoc "Listen on path or localhost port in discovery mode.";
      };
      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [ "--shortlog" ];
        example = [ "--verbose" "--no-http" "--ipv4only" "--no-host" ];
        description = lib.mdDoc "Additional wsdd options.";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.wsdd ];

    systemd.services.samba-wsdd = {
      description = "Web Services Dynamic Discovery host daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        Type = "simple";
        ExecStart = ''
          ${pkgs.wsdd}/bin/wsdd ${optionalString (cfg.interface != null) "--interface '${cfg.interface}'"} \
                                ${optionalString (cfg.hoplimit != null) "--hoplimit '${toString cfg.hoplimit}'"} \
                                ${optionalString (cfg.workgroup != null) "--workgroup '${cfg.workgroup}'"} \
                                ${optionalString (cfg.hostname != null) "--hostname '${cfg.hostname}'"} \
                                ${optionalString (cfg.domain != null) "--domain '${cfg.domain}'"} \
                                ${optionalString cfg.discovery "--discovery --listen '${cfg.listen}'"} \
                                ${escapeShellArgs cfg.extraOptions}
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
  };
}
