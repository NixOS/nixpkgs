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

      systemd.services.softether-init = {
        description = "SoftEther VPN services initial task";
        wantedBy = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = false;
        };
        script = ''
            for d in vpnserver vpnbridge vpnclient vpncmd; do
                if ! test -e ${cfg.dataDir}/$d; then
                    ${pkgs.coreutils}/bin/mkdir -m0700 -p ${cfg.dataDir}/$d
                    install -m0600 ${package}${cfg.dataDir}/$d/hamcore.se2 ${cfg.dataDir}/$d/hamcore.se2
                fi
            done
            rm -rf ${cfg.dataDir}/vpncmd/vpncmd
            ln -s ${package}${cfg.dataDir}/vpncmd/vpncmd ${cfg.dataDir}/vpncmd/vpncmd
        '';
      };
    }

    (mkIf cfg.vpnserver.enable {
      systemd.services.vpnserver = {
        description = "SoftEther VPN Server";
        after = [ "softether-init.service" ];
        requires = [ "softether-init.service" ];
        wantedBy = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${package}/bin/vpnserver start";
          ExecStop = "${package}/bin/vpnserver stop";
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
        after = [ "softether-init.service" ];
        requires = [ "softether-init.service" ];
        wantedBy = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${package}/bin/vpnbridge start";
          ExecStop = "${package}/bin/vpnbridge stop";
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
        after = [ "softether-init.service" ];
        requires = [ "softether-init.service" ];
        wantedBy = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${package}/bin/vpnclient start";
          ExecStop = "${package}/bin/vpnclient stop";
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

  ]);

}
