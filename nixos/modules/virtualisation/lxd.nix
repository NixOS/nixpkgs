# Systemd services for lxd.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.lxd;

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
        '';
      };
      zfsSupport = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enables lxd to use zfs as a storage for containers.
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

    environment.systemPackages = [ pkgs.lxd ];

    security.apparmor = {
      enable = true;
      profiles = [
        "${pkgs.lxc}/etc/apparmor.d/usr.bin.lxc-start"
        "${pkgs.lxc}/etc/apparmor.d/lxc-containers"
      ];
      packages = [ pkgs.lxc ];
    };

    systemd.services.lxd = {
      description = "LXD Container Management Daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];

      path = lib.optional cfg.zfsSupport pkgs.zfs;

      preStart = ''
        mkdir -m 0755 -p /var/lib/lxc/rootfs
      '';

      serviceConfig = {
        ExecStart = "@${pkgs.lxd.bin}/bin/lxd lxd --group lxd";
        Type = "simple";
        KillMode = "process"; # when stopping, leave the containers alone
        LimitMEMLOCK = "infinity";
        LimitNOFILE = "1048576";
        LimitNPROC = "infinity";
        TasksMax = "infinity";
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
