{ pkgs
, lib
, config
, ...
}:

with lib;

let

  cfg = config.services.pihole-ftl;
  stateDir = "/etc/pihole";
  confFile = "${stateDir}/pihole-FTL.conf";
  logFile = "/var/log/pihole-FTL.log";
  confText = pkgs.writeText "pihole-FTL.conf" cfg.config;

in
{

  options.services.pihole-ftl = {
    enable = mkEnableOption "Pi-hole FTL";

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open ports in the firewall for Pi-hole FTL.";
    };

    config = mkOption {
      type = types.lines;
      default = "";
      description = "Configuration file content for Pi-hole FTL.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pihole-ftl;
      defaultText = "pkgs.pihole-ftl";
      description = "Pi-hole FTL package to use.";
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = !config.services.dnsmasq.enable;
        message = "pihole-ftl conflicts with dnsmasq";
      }
    ];

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0700 pihole pihole - -"
      "L+ ${confFile} - - - - ${confText}"
      "f ${logFile} 0700 pihole pihole - -"
    ];

    systemd.services.pihole-ftl = {
      description = "Pi-hole FTL";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "pihole";
        Group = "pihole";
        AmbientCapabilities = [
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
          "CAP_NET_ADMIN"
          "CAP_SYS_NICE"
        ];
        ExecStart = "${cfg.package}/bin/pihole-FTL no-daemon";
        Restart = "on-failure";
        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ReadWritePaths = [ stateDir logFile ];
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };

    users.users.pihole = {
      group = "pihole";
      isSystemUser = true;
    };

    users.groups.pihole = { };
  };
}
