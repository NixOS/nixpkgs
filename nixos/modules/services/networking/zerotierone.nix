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
      List of ZeroTier Network IDs to join on startup. This option is impure.
      To actually leave a network after removing it from this list, you will have to manually run `zerotier-cli leave <NETWORK_ID>`.
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

  options.services.zerotierone.localConfSourcePath = mkOption {
    default = null;
    type = types.nullOr types.path;
    description = lib.mdDoc ''
      Optional path to a file to be used as source of the local.conf file. Contents will be copied into /var/lib/zerotier-one/local.conf file.
    '';
  };

  config = mkIf cfg.enable {
    assertions = [ {
      assertion = (pathExists /var/lib/zerotier-one/local.conf) -> (
        pathExists /var/lib/zerotier-one/local.conf.managed-by-nixos
      );
      message = ''
        Found /var/lib/zerotier-one/local.conf file but no
          /var/lib/zerotier-one/local.conf.managed-by-nixos file found. This can
          happen when updating to a newer version of zerotierone module (which now
          manages the local.conf file itself), while having previously manually
          created /var/lib/zerotier-one/local.conf yourself. To proceed, please
          copy the local.conf file elsewhere (such as into /etc/nixos) and point
          to the file via options.services.zerotierone.localConfSourcePath option.
      '';
    } ];

    systemd.services.zerotierone = let
      # make sure changes to the contents of the source file are noticed;
      # note that it needs to be used to "work", so echo it below;
      # also note that hashFile tolerates null argument;
      # this also serves as a check that file exists if specified
      localConfHash = builtins.hashFile "sha512" cfg.localConfSourcePath;
    in
    {
      description = "ZeroTierOne";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      wants = [ "network-online.target" ];

      path = [ cfg.package ];

      preStart = ''
        mkdir -p /var/lib/zerotier-one/networks.d
        chmod 700 /var/lib/zerotier-one
        chown -R root:root /var/lib/zerotier-one
        touch /var/lib/zerotier-one/local.conf.managed-by-nixos
      '' + (
        concatMapStrings (netId: ''
          touch "/var/lib/zerotier-one/networks.d/${netId}.conf"
        '') cfg.joinNetworks
      ) + (
        if (cfg.localConfSourcePath != null) then ''
          echo "local.conf hash: ${localConfHash}"
          cat ${escapeShellArg cfg.localConfSourcePath} > /var/lib/zerotier-one/local.conf
        '' else ''
          echo "{}" > /var/lib/zerotier-one/local.conf
        ''
      );

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
