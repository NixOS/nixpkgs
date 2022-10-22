{ config, pkgs, lib, ... }:

with lib;

let cfg = config.services.nzbhydra2;

in {
  options = {
    services.nzbhydra2 = {
      enable = mkEnableOption (lib.mdDoc "NZBHydra2");

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/nzbhydra2";
        description = lib.mdDoc "The directory where NZBHydra2 stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description =
          lib.mdDoc "Open ports in the firewall for the NZBHydra2 web interface.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.nzbhydra2;
        defaultText = literalExpression "pkgs.nzbhydra2";
        description = lib.mdDoc "NZBHydra2 package to use.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules =
      [ "d '${cfg.dataDir}' 0700 nzbhydra2 nzbhydra2 - -" ];

    systemd.services.nzbhydra2 = {
      description = "NZBHydra2";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "nzbhydra2";
        Group = "nzbhydra2";
        ExecStart =
          "${cfg.package}/bin/nzbhydra2 --nobrowser --datafolder '${cfg.dataDir}'";
        Restart = "on-failure";
        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ReadWritePaths = cfg.dataDir;
        ProtectHome = "read-only";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies ="AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
      };
    };

    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ 5076 ]; };

    users.users.nzbhydra2 = {
      group = "nzbhydra2";
      isSystemUser = true;
    };

    users.groups.nzbhydra2 = {};
  };
}
