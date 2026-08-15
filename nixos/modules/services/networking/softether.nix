{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.softether;

  package = cfg.package.override { inherit (cfg) dataDir; };

in
{

  ###### interface

  options = {

    services.softether = {

      enable = mkEnableOption "SoftEther VPN services";

      package = mkPackageOption pkgs "softether" { };

      vpnserver.enable = mkEnableOption "SoftEther VPN Server";

      vpnbridge.enable = mkEnableOption "SoftEther VPN Bridge";

      vpnclient = {
        enable = mkEnableOption "SoftEther VPN Client";
        up = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Shell commands executed when the Virtual Network Adapter(s) is/are starting.
          '';
        };
        down = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Shell commands executed when the Virtual Network Adapter(s) is/are shutting down.
          '';
        };
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/softether";
        description = ''
          Data directory for SoftEther VPN.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable (

    mkMerge [
      {
        environment.systemPackages = [ package ];

        systemd.tmpfiles.rules = [
          "d  ${cfg.dataDir}/vpnserver             700 root root"
          "L+ ${cfg.dataDir}/vpnserver/hamcore.se2 -   -    -     - ${package}${cfg.dataDir}/vpnserver/hamcore.se2"
          "L+ ${cfg.dataDir}/vpnserver/vpnserver   -   -    -     - ${package}${cfg.dataDir}/vpnserver/vpnserver"
          "d  ${cfg.dataDir}/vpnbridge             700 root root"
          "L+ ${cfg.dataDir}/vpnbridge/hamcore.se2 -   -    -     - ${package}${cfg.dataDir}/vpnbridge/hamcore.se2"
          "L+ ${cfg.dataDir}/vpnbridge/vpnbridge   -   -    -     - ${package}${cfg.dataDir}/vpnbridge/vpnbridge"
          "d  ${cfg.dataDir}/vpnclient             700 root root"
          "L+ ${cfg.dataDir}/vpnclient/hamcore.se2 -   -    -     - ${package}${cfg.dataDir}/vpnclient/hamcore.se2"
          "L+ ${cfg.dataDir}/vpnclient/vpnclient   -   -    -     - ${package}${cfg.dataDir}/vpnclient/vpnclient"
          "d  ${cfg.dataDir}/vpncmd                700 root root"
          "L+ ${cfg.dataDir}/vpncmd/hamcore.se2    -   -    -     - ${package}${cfg.dataDir}/vpncmd/hamcore.se2"
          "L+ ${cfg.dataDir}/vpncmd/vpncmd         -   -    -     - ${package}${cfg.dataDir}/vpncmd/vpncmd"
        ];
      }

      (mkIf cfg.vpnserver.enable {
        systemd.services.vpnserver = {
          description = "SoftEther VPN Server";
          wantedBy = [ "network.target" ];
          serviceConfig = {
            Type = "forking";
            ExecStart = "${cfg.dataDir}/vpnserver/vpnserver start";
            ExecStop = "${cfg.dataDir}/vpnserver/vpnserver stop";
            Restart = "on-failure";

            # Hardening
            PrivateTmp = true;
            ProtectHome = true;
            ProtectSystem = "full";
            ReadOnlyPaths = "/";
            ReadWritePaths = "${cfg.dataDir}/vpnserver";
            CapabilityBoundingSet = [
              "CAP_NET_ADMIN"
              "CAP_NET_BIND_SERVICE"
              "CAP_NET_BROADCAST"
              "CAP_NET_RAW"
              "CAP_SYS_NICE"
              "CAP_SYSLOG"
              "CAP_SETUID"
            ];
          };
          preStart = ''
            rm -rf ${cfg.dataDir}/vpnserver/vpnserver
            ln -s ${package}${cfg.dataDir}/vpnserver/vpnserver ${cfg.dataDir}/vpnserver/vpnserver
          '';
          postStop = ''
            rm -rf ${cfg.dataDir}/vpnserver/vpnserver
          '';
        };
      })

      (mkIf cfg.vpnbridge.enable {
        systemd.services.vpnbridge = {
          description = "SoftEther VPN Bridge";
          wantedBy = [ "network.target" ];
          serviceConfig = {
            Type = "forking";
            ExecStart = "${cfg.dataDir}/vpnbridge/vpnbridge start";
            ExecStop = "${cfg.dataDir}/vpnbridge/vpnbridge stop";
            Restart = "on-failure";

            # Hardening
            PrivateTmp = true;
            ProtectHome = true;
            ProtectSystem = "full";
            ReadOnlyPaths = "/";
            ReadWritePaths = "${cfg.dataDir}/vpnbridge";
            CapabilityBoundingSet = [
              "CAP_NET_ADMIN"
              "CAP_NET_BIND_SERVICE"
              "CAP_NET_BROADCAST"
              "CAP_NET_RAW"
              "CAP_SYS_NICE"
              "CAP_SYSLOG"
              "CAP_SETUID"
            ];
          };
          preStart = ''
            rm -rf ${cfg.dataDir}/vpnbridge/vpnbridge
            ln -s ${package}${cfg.dataDir}/vpnbridge/vpnbridge ${cfg.dataDir}/vpnbridge/vpnbridge
          '';
          postStop = ''
            rm -rf ${cfg.dataDir}/vpnbridge/vpnbridge
          '';
        };
      })

      (mkIf cfg.vpnclient.enable {
        systemd.services.vpnclient = {
          description = "SoftEther VPN Client";
          wantedBy = [ "network.target" ];
          serviceConfig = {
            Type = "forking";
            ExecStart = "${cfg.dataDir}/vpnclient/vpnclient start";
            ExecStop = "${cfg.dataDir}/vpnclient/vpnclient stop";
            Restart = "on-failure";

            # Hardening
            PrivateTmp = true;
            ProtectHome = true;
            ProtectSystem = "full";
            ReadWritePaths = "${cfg.dataDir}/vpnclient";
            CapabilityBoundingSet = [
              "CAP_NET_ADMIN"
              "CAP_NET_BIND_SERVICE"
              "CAP_NET_BROADCAST"
              "CAP_NET_RAW"
              "CAP_SYS_NICE"
              "CAP_SYSLOG"
              "CAP_SETUID"
            ];
          };
          preStart = ''
            rm -rf ${cfg.dataDir}/vpnclient/vpnclient
            ln -s ${package}${cfg.dataDir}/vpnclient/vpnclient ${cfg.dataDir}/vpnclient/vpnclient
          '';
          postStart = ''
            sleep 1
            ${cfg.vpnclient.up}
          '';
          postStop = ''
            rm -rf ${cfg.dataDir}/vpnclient/vpnclient
            sleep 1
            ${cfg.vpnclient.down}
          '';
        };
        boot.kernelModules = [ "tun" ];
      })

    ]
  );

}
