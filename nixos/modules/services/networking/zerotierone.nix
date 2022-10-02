{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zerotierone;
in
{
  options.services.zerotierone.enable = mkEnableOption (lib.mdDoc "ZeroTierOne");

  options.services.zerotierone.joinNetworks = mkOption {
    default = [];
    example = [ "a8a2c3c10c1a68de" ];
    type = types.listOf types.str;
    description = lib.mdDoc ''
      List of ZeroTier Network IDs to join on startup
    '';
  };

  options.services.zerotierone.port = mkOption {
    default = 9993;
    type = types.int;
    description = lib.mdDoc ''
      Network port used by ZeroTier.
    '';
  };

  options.services.zerotierone.package = mkOption {
    default = pkgs.zerotierone;
    defaultText = literalExpression "pkgs.zerotierone";
    type = types.package;
    description = lib.mdDoc ''
      ZeroTier One package to use.
    '';
  };

  config = mkIf cfg.enable {
    systemd.services.zerotierone = {
      description = "ZeroTierOne";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      wants = [ "network-online.target" ];

      path = [ cfg.package ];

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
        TimeoutStopSec = 5;
      };
    };

    # ZeroTier does not issue DHCP leases, but some strangers might...
    networking.dhcpcd.denyInterfaces = [ "zt*" ];

    # ZeroTier receives UDP transmissions
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    environment.systemPackages = [ cfg.package ];

    # Prevent systemd from potentially changing the MAC address
    systemd.network.links."50-zerotier" = {
      matchConfig = {
        OriginalName = "zt*";
      };
      linkConfig = {
        AutoNegotiation = false;
        MACAddressPolicy = "none";
      };
    };
  };
}
