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
      confinement = {
        enable = true;
        packages = [ pkgs.coreutils ];
        mode = "chroot-only";
      };
      bindsTo = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p /var/lib/zerotier-one/networks.d
      '' + (concatMapStrings (netId: ''
        touch "/var/lib/zerotier-one/networks.d/${netId}.conf"
      '') cfg.joinNetworks);

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/zerotier-one -p${toString cfg.port}";
        Restart = "always";
        KillMode = "process";
        StateDirectory = "zerotier-one";
        StateDirectoryMode = "0700";

        CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @resources";

        # If either of these is set, zerotier-one v1.1.12 fails on a
        # pthread_create call.
        DynamicUser = false;  # If true, requires -U flag to zerotier-one.
        MemoryDenyWriteExecute = false;

        # If this is set, zerotier-one v1.1.12 fails on an ioctl call
        # to configure its network device for TAP operation.
        PrivateUsers = false;
      };
    };

    # ZeroTier does not issue DHCP leases, but some strangers might...
    networking.dhcpcd.denyInterfaces = [ "zt*" ];

    # ZeroTier receives UDP transmissions
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    environment.systemPackages = [ cfg.package ];
  };
}
