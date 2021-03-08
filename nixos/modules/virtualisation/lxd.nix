# Systemd services for lxd.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.lxd;
  zfsCfg = config.boot.zfs;

in

{
  ###### interface

  options = {
    virtualisation.lxd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          This option enables lxd, a daemon that manages
          containers. Users in the "lxd" group can interact with
          the daemon (e.g. to start or stop containers) using the
          <command>lxc</command> command line tool, among others.

          Most of the time, you'll also want to start lxcfs, so
          that containers can "see" the limits:
          <code>
            virtualisation.lxc.lxcfs.enable = true;
          </code>
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.lxd.override { nftablesSupport = config.networking.nftables.enable; };
        defaultText = "pkgs.lxd";
        description = ''
          The LXD package to use.
        '';
      };

      lxcPackage = mkOption {
        type = types.package;
        default = pkgs.lxc;
        defaultText = "pkgs.lxc";
        description = ''
          The LXC package to use with LXD (required for AppArmor profiles).
        '';
      };

      zfsPackage = mkOption {
        type = types.package;
        default = with pkgs; if zfsCfg.enableUnstable then zfsUnstable else zfs;
        defaultText = "pkgs.zfs";
        description = ''
          The ZFS package to use with LXD.
        '';
      };

      zfsSupport = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables lxd to use zfs as a storage for containers.

          This option is enabled by default if a zfs pool is configured
          with nixos.
        '';
      };

      recommendedSysctlSettings = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enables various settings to avoid common pitfalls when
          running containers requiring many file operations.
          Fixes errors like "Too many open files" or
          "neighbour: ndisc_cache: neighbor table overflow!".
          See https://lxd.readthedocs.io/en/latest/production-setup/
          for details.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.apparmor = {
      enable = true;
      profiles = [
        "${cfg.lxcPackage}/etc/apparmor.d/usr.bin.lxc-start"
        "${cfg.lxcPackage}/etc/apparmor.d/lxc-containers"
      ];
      packages = [ cfg.lxcPackage ];
    };

    # TODO: remove once LXD gets proper support for cgroupsv2
    # (currently most of the e.g. CPU accounting stuff doesn't work)
    systemd.enableUnifiedCgroupHierarchy = false;

    systemd.services.lxd = {
      description = "LXD Container Management Daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];

      path = lib.optional cfg.zfsSupport cfg.zfsPackage;

      preStart = ''
        mkdir -m 0755 -p /var/lib/lxc/rootfs
      '';

      serviceConfig = {
        ExecStart = "@${cfg.package}/bin/lxd lxd --group lxd";
        Type = "simple";
        KillMode = "process"; # when stopping, leave the containers alone
        LimitMEMLOCK = "infinity";
        LimitNOFILE = "1048576";
        LimitNPROC = "infinity";
        TasksMax = "infinity";

        # By default, `lxd` loads configuration files from hard-coded
        # `/usr/share/lxc/config` - since this is a no-go for us, we have to
        # explicitly tell it where the actual configuration files are
        Environment = mkIf (config.virtualisation.lxc.lxcfs.enable)
          "LXD_LXC_TEMPLATE_CONFIG=${pkgs.lxcfs}/share/lxc/config";
      };
    };

    users.groups.lxd.gid = config.ids.gids.lxd;

    users.users.root = {
      subUidRanges = [ { startUid = 1000000; count = 65536; } ];
      subGidRanges = [ { startGid = 1000000; count = 65536; } ];
    };

    boot.kernel.sysctl = mkIf cfg.recommendedSysctlSettings {
      "fs.inotify.max_queued_events" = 1048576;
      "fs.inotify.max_user_instances" = 1048576;
      "fs.inotify.max_user_watches" = 1048576;
      "vm.max_map_count" = 262144;
      "kernel.dmesg_restrict" = 1;
      "net.ipv4.neigh.default.gc_thresh3" = 8192;
      "net.ipv6.neigh.default.gc_thresh3" = 8192;
      "kernel.keys.maxkeys" = 2000;
    };
  };
}
