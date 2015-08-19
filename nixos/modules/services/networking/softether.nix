{ config, lib, pkgs, ... }:

with lib;

let
  pkg = pkgs.softether;
  cfg = config.services.softether;

in
{

  ###### interface

  options = {

    services.softether = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the SoftEther VPN services.
        '';
      };

      vpnserver.enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable the SoftEther VPN Server.
          '';
      };

      vpnbridge.enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable the SoftEther VPN Bridge.
          '';
      };

      vpnclient = {
        enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to enable the SoftEther VPN Client.
            '';
        };

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
          type = types.string;
          default = "${pkg.dataDir}";
          description = ''
            Data directory for SoftEther VPN.
          '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable (

    mkMerge [{
      environment.systemPackages = [
        (pkgs.lib.overrideDerivation pkg (attrs: {
          dataDir = cfg.dataDir;
        }))
      ];

      jobs.softether = {
        description = "SoftEther VPN services initial job";
        startOn = "started network-interfaces";
        preStart = ''
          for d in vpnserver vpnbridge vpnclient vpncmd; do
            if ! test -e ${cfg.dataDir}/$d; then
              ${pkgs.coreutils}/bin/mkdir -m0700 -p ${cfg.dataDir}/$d
              install -m0600 ${pkg}${cfg.dataDir}/$d/hamcore.se2 ${cfg.dataDir}/$d/hamcore.se2
              install -m0700 ${pkg}${cfg.dataDir}/$d/$d ${cfg.dataDir}/$d/$d
            fi
          done
        '';
        exec = "true";
      };
    }

    (mkIf (cfg.vpnserver.enable) {
      systemd.services.vpnserver = {
        description = "SoftEther VPN Server";
        after = [ "network-interfaces.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkg}/bin/vpnserver start";
          ExecStop = "${pkg}/bin/vpnserver stop";
          Type = "forking";
        };
      };
    })

    (mkIf (cfg.vpnbridge.enable) {
      systemd.services.vpnbridge = {
        description = "SoftEther VPN Bridge";
        after = [ "network-interfaces.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkg}/bin/vpnbridge start";
          ExecStop = "${pkg}/bin/vpnbridge stop";
          Type = "forking";
        };
      };
    })

    (mkIf (cfg.vpnclient.enable) {
      systemd.services.vpnclient = {
        description = "SoftEther VPN Client";

        after = [ "network-interfaces.target" ];

        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${pkg}/bin/vpnclient start";
          ExecStop = "${pkg}/bin/vpnclient stop";
          Type = "forking";
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
