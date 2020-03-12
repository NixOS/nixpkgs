{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zerotierone;
in
{
  options.services.zerotierone.enable = mkEnableOption "ZeroTierOne";

  options.services.zerotierone.joinNetworks = mkOption {
    default = [];
    example = [ "a8a2c3c10c1a68de" ];
    type = types.listOf types.str;
    description = ''
      List of ZeroTier Network IDs to join on startup
    '';
  };

  options.services.zerotierone.port = mkOption {
    default = 9993;
    example = 9993;
    type = types.int;
    description = ''
      Network port used by ZeroTier.
    '';
  };

  options.services.zerotierone.package = mkOption {
    default = pkgs.zerotierone;
    defaultText = "pkgs.zerotierone";
    type = types.package;
    description = ''
      ZeroTier One package to use.
    '';
  };

  config = mkIf cfg.enable {
    systemd.services.zerotierone = {
      description = "ZeroTierOne";
      path = [ cfg.package ];
      bindsTo = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p /var/lib/zerotier-one/networks.d
        chmod 700 /var/lib/zerotier-one
        chown -R root:root /var/lib/zerotier-one
      '' + (concatMapStrings (netId: ''
        touch "/var/lib/zerotier-one/networks.d/${netId}.conf"
      '') cfg.joinNetworks);
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/zerotier-one -p${toString cfg.port}";
        Restart = "always";
        KillMode = "process";
      };
    };

    # ZeroTier does not issue DHCP leases, but some strangers might...
    networking.dhcpcd.denyInterfaces = [ "zt*" ];

    # ZeroTier receives UDP transmissions
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    environment.systemPackages = [ cfg.package ];

    # Prevent systemd from potentially changing the MAC address
    environment.etc."systemd/network/50-zerotier.link".text = ''
      [Match]
      OriginalName=zt*

      [Link]
      AutoNegotiation=false
      MACAddressPolicy=none
    '';
  };
}
