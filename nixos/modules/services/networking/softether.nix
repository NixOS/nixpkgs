{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.softether;

  package = cfg.package.override { inherit (cfg) dataDir; };

in
{

  ###### interface

  options = {

    services.softether = {

      enable = mkEnableOption (lib.mdDoc "SoftEther VPN services");

      package = mkPackageOption pkgs "softether" { };

      vpnserver.enable = mkEnableOption (lib.mdDoc "SoftEther VPN Server");

      vpnbridge.enable = mkEnableOption (lib.mdDoc "SoftEther VPN Bridge");

      vpnclient = {
        enable = mkEnableOption (lib.mdDoc "SoftEther VPN Client");
        up = mkOption {
          type = types.lines;
          default = "";
          description = lib.mdDoc ''
            Shell commands executed when the Virtual Network Adapter(s) is/are starting.
          '';
        };
        down = mkOption {
          type = types.lines;
          default = "";
          description = lib.mdDoc ''
            Shell commands executed when the Virtual Network Adapter(s) is/are shutting down.
          '';
        };
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/softether";
        description = lib.mdDoc ''
          Data directory for SoftEther VPN.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable (

    mkMerge [{
      environment.systemPackages = [ package ];

      systemd.tmpfiles.rules = [
        "d  ${cfg.dataDir}/vpnserver             755 root root"
        "L+ ${cfg.dataDir}/vpnserver/hamcore.se2 -   -    -     - ${package}${cfg.dataDir}/vpnserver/hamcore.se2"
        "L+ ${cfg.dataDir}/vpnserver/vpnserver   -   -    -     - ${package}${cfg.dataDir}/vpnserver/vpnserver"
        "d  ${cfg.dataDir}/vpnbridge             755 root root"
        "L+ ${cfg.dataDir}/vpnbridge/hamcore.se2 -   -    -     - ${package}${cfg.dataDir}/vpnbridge/hamcore.se2"
        "L+ ${cfg.dataDir}/vpnbridge/vpnbridge   -   -    -     - ${package}${cfg.dataDir}/vpnbridge/vpnbridge"
        "d  ${cfg.dataDir}/vpnclient             755 root root"
        "L+ ${cfg.dataDir}/vpnclient/hamcore.se2 -   -    -     - ${package}${cfg.dataDir}/vpnclient/hamcore.se2"
        "L+ ${cfg.dataDir}/vpnclient/vpnclient   -   -    -     - ${package}${cfg.dataDir}/vpnclient/vpnclient"
        "d  ${cfg.dataDir}/vpncmd                755 root root"
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
          ExecStart = "${package}/bin/vpnserver start";
          ExecStop = "${package}/bin/vpnserver stop";
        };
      };
    })

    (mkIf cfg.vpnbridge.enable {
      systemd.services.vpnbridge = {
        description = "SoftEther VPN Bridge";
        wantedBy = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${package}/bin/vpnbridge start";
          ExecStop = "${package}/bin/vpnbridge stop";
        };
      };
    })

    (mkIf cfg.vpnclient.enable {
      systemd.services.vpnclient = {
        description = "SoftEther VPN Client";
        wantedBy = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${package}/bin/vpnclient start";
          ExecStop = "${package}/bin/vpnclient stop";
        };
        postStart = ''
            sleep 1
            ${cfg.vpnclient.up}
        '';
        postStop = ''
            sleep 1
            ${cfg.vpnclient.down}
        '';
      };
      boot.kernelModules = [ "tun" ];
    })

  ]);

}
