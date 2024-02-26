{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.boot.initrd.network.openvpn;

in

{

  options = {

    boot.initrd.network.openvpn.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Starts an OpenVPN client during initrd boot. It can be used to e.g.
        remotely accessing the SSH service controlled by
        {option}`boot.initrd.network.ssh` or other network services
        included. Service is killed when stage-1 boot is finished.
      '';
    };

    boot.initrd.network.openvpn.configuration = mkOption {
      type = types.path; # Same type as boot.initrd.secrets
      description = lib.mdDoc ''
        The configuration file for OpenVPN.

        ::: {.warning}
        Unless your bootloader supports initrd secrets, this configuration
        is stored insecurely in the global Nix store.
        :::
      '';
      example = literalExpression "./configuration.ovpn";
    };

  };

  config = mkIf (config.boot.initrd.systemd.network.enable && cfg.enable) {
    assertions = [
      {
        assertion = cfg.configuration != null;
        message = "You should specify a configuration for initrd OpenVPN";
      }
    ];

    # Add kernel modules needed for OpenVPN
    boot.initrd.kernelModules = [ "tun" "tap" ];

    boot.initrd.systemd.storePaths = [
      "${pkgs.openvpn}/bin/openvpn"
      "${pkgs.iproute2}/bin/ip"
      "${pkgs.glibc}/lib/libresolv.so.2"
      "${pkgs.glibc}/lib/libnss_dns.so.2"
    ];

    boot.initrd.secrets = {
      "/etc/initrd.ovpn" = cfg.configuration;
    };

    boot.initrd.systemd.services.openvpn = {
      wantedBy = [ "initrd.target" ];
      path = [ pkgs.iproute2 ];
      after = [ "network.target" "initrd-nixos-copy-secrets.service" ];
      serviceConfig.ExecStart = "${pkgs.openvpn}/bin/openvpn /etc/initrd.ovpn";
      serviceConfig.Type = "notify";
    };
  };

}
