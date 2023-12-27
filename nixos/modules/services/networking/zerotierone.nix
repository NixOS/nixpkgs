{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zerotierone;
  localConfFile = pkgs.writeText "zt-local.conf" (builtins.toJSON cfg.localConf);
  localConfFilePath = "/var/lib/zerotier-one/local.conf";
in
{
  options.services.zerotierone.enable = mkEnableOption (lib.mdDoc "ZeroTierOne");

  options.services.zerotierone.joinNetworks = mkOption {
    default = [];
    example = [ "a8a2c3c10c1a68de" ];
    type = types.listOf types.str;
    description = lib.mdDoc ''
      List of ZeroTier Network IDs to join on startup.
      Note that networks are only ever joined, but not automatically left after removing them from the list.
      To remove networks, use the ZeroTier CLI: `zerotier-cli leave <network-id>`
    '';
  };

  options.services.zerotierone.port = mkOption {
    default = 9993;
    type = types.port;
    description = lib.mdDoc ''
      Network port used by ZeroTier.
    '';
  };

  options.services.zerotierone.package = mkPackageOption pkgs "zerotierone" { };

  options.services.zerotierone.localConf = mkOption {
    default = null;
    description = mdDoc ''
      Optional configuration to be written to the Zerotier JSON-based local.conf.
      If set, the configuration will be symlinked to `/var/lib/zerotier-one/local.conf` at build time.
      To understand the configuration format, refer to https://docs.zerotier.com/config/#local-configuration-options.
    '';
    example = {
      settings.allowTcpFallbackRelay = false;
    };
    type = types.nullOr types.attrs;
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
      '') cfg.joinNetworks) + optionalString (cfg.localConf != null) ''
        if [ -L "${localConfFilePath}" ]
        then
          rm ${localConfFilePath}
        elif [ -f "${localConfFilePath}" ]
        then
          mv ${localConfFilePath} ${localConfFilePath}.bak
        fi
        ln -s ${localConfFile} ${localConfFilePath}
      '';

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
