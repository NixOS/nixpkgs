{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.boot.initrd.network.openvpn;

in

{

  options = {

    boot.initrd.network.openvpn.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Starts an OpenVPN client during initrd boot. It can be used to e.g.
        remotely accessing the SSH service controlled by
        {option}`boot.initrd.network.ssh` or other network services
        included. Service is killed when stage-1 boot is finished.
      '';
    };

    boot.initrd.network.openvpn.configuration = mkOption {
      type = types.path; # Same type as boot.initrd.secrets
      description = ''
        The configuration file for OpenVPN.

        ::: {.warning}
        Unless your bootloader supports initrd secrets, this configuration
        is stored insecurely in the global Nix store.
        :::
      '';
      example = literalExpression "./configuration.ovpn";
    };

  };

  config = mkIf (config.boot.initrd.network.enable && cfg.enable) {
    assertions = [
      {
        assertion = cfg.configuration != null;
        message = "You should specify a configuration for initrd OpenVPN";
      }
    ];

    # Add kernel modules needed for OpenVPN
    boot.initrd.kernelModules = [
      "tun"
      "tap"
    ];

    # Add openvpn and ip binaries to the initrd
    # The shared libraries are required for DNS resolution
    boot.initrd.extraUtilsCommands = mkIf (!config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.openvpn}/bin/openvpn
      copy_bin_and_libs ${pkgs.iproute2}/bin/ip

      cp -pv ${pkgs.glibc}/lib/libresolv.so.2 $out/lib
      cp -pv ${pkgs.glibc}/lib/libnss_dns.so.2 $out/lib
    '';

    boot.initrd.systemd.storePaths = [
      "${pkgs.openvpn}/bin/openvpn"
      "${pkgs.iproute2}/bin/ip"
      "${pkgs.glibc}/lib/libresolv.so.2"
      "${pkgs.glibc}/lib/libnss_dns.so.2"
    ];

    boot.initrd.secrets = {
      "/etc/initrd.ovpn" = cfg.configuration;
    };

    # openvpn --version would exit with 1 instead of 0
    boot.initrd.extraUtilsCommandsTest = mkIf (!config.boot.initrd.systemd.enable) ''
      $out/bin/openvpn --show-gateway
    '';

    boot.initrd.network.postCommands = mkIf (!config.boot.initrd.systemd.enable) ''
      openvpn /etc/initrd.ovpn &
    '';

    boot.initrd.systemd.services.openvpn = {
      wantedBy = [ "initrd.target" ];
      path = [ pkgs.iproute2 ];
      after = [
        "network.target"
        "initrd-nixos-copy-secrets.service"
      ];
      serviceConfig.ExecStart = "${pkgs.openvpn}/bin/openvpn /etc/initrd.ovpn";
      serviceConfig.Type = "notify";
    };
  };

}
