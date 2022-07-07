# Systemd services for lxd.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.lxd;
in {
  imports = [
    (mkRemovedOptionModule [ "virtualisation" "lxd" "zfsPackage" ] "Override zfs in an overlay instead to override it globally")
  ];

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
        default = pkgs.lxd;
        defaultText = literalExpression "pkgs.lxd";
        description = ''
          The LXD package to use.
        '';
      };

      lxcPackage = mkOption {
        type = types.package;
        default = pkgs.lxc;
        defaultText = literalExpression "pkgs.lxc";
        description = ''
          The LXC package to use with LXD (required for AppArmor profiles).
        '';
      };

      zfsSupport = mkOption {
        type = types.bool;
        default = config.boot.zfs.enabled;
        defaultText = literalExpression "config.boot.zfs.enabled";
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
          Enables various settings to avoid common pitfalls when
          running containers requiring many file operations.
          Fixes errors like "Too many open files" or
          "neighbour: ndisc_cache: neighbor table overflow!".
          See https://lxd.readthedocs.io/en/latest/production-setup/
          for details.
        '';
      };

      startTimeout = mkOption {
        type = types.int;
        default = 600;
        apply = toString;
        description = ''
          Time to wait (in seconds) for LXD to become ready to process requests.
          If LXD does not reply within the configured time, lxd.service will be
          considered failed and systemd will attempt to restart it.
        '';
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Note: the following options are also declared in virtualisation.lxc, but
    # the latter can't be simply enabled to reuse the formers, because it
    # does a bunch of unrelated things.
    systemd.tmpfiles.rules = [ "d /var/lib/lxc/rootfs 0755 root root -" ];

    security.apparmor = {
      packages = [ cfg.lxcPackage ];
      policies = {
        "bin.lxc-start".profile = ''
          include ${cfg.lxcPackage}/etc/apparmor.d/usr.bin.lxc-start
        '';
        "lxc-containers".profile = ''
          include ${cfg.lxcPackage}/etc/apparmor.d/lxc-containers
        '';
      };
    };

    # TODO: remove once LXD gets proper support for cgroupsv2
    # (currently most of the e.g. CPU accounting stuff doesn't work)
    systemd.enableUnifiedCgroupHierarchy = false;

    systemd.sockets.lxd = {
      description = "LXD UNIX socket";
      wantedBy = [ "sockets.target" ];

      socketConfig = {
        ListenStream = "/var/lib/lxd/unix.socket";
        SocketMode = "0660";
        SocketGroup = "lxd";
        Service = "lxd.service";
      };
    };

    systemd.services.lxd = {
      description = "LXD Container Management Daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "lxcfs.service" ];
      requires = [ "network-online.target" "lxd.socket"  "lxcfs.service" ];
      documentation = [ "man:lxd(1)" ];

      path = optional cfg.zfsSupport config.boot.zfs.package;

      serviceConfig = {
        ExecStart = "@${cfg.package}/bin/lxd lxd --group lxd";
        ExecStartPost = "${cfg.package}/bin/lxd waitready --timeout=${cfg.startTimeout}";
        ExecStop = "${cfg.package}/bin/lxd shutdown";

        KillMode = "process"; # when stopping, leave the containers alone
        LimitMEMLOCK = "infinity";
        LimitNOFILE = "1048576";
        LimitNPROC = "infinity";
        TasksMax = "infinity";

        Restart = "on-failure";
        TimeoutStartSec = "${cfg.startTimeout}s";
        TimeoutStopSec = "30s";

        # By default, `lxd` loads configuration files from hard-coded
        # `/usr/share/lxc/config` - since this is a no-go for us, we have to
        # explicitly tell it where the actual configuration files are
        Environment = mkIf (config.virtualisation.lxc.lxcfs.enable)
          "LXD_LXC_TEMPLATE_CONFIG=${pkgs.lxcfs}/share/lxc/config";
      };
    };

    users.groups.lxd = {};

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

    boot.kernelModules = [ "veth" "xt_comment" "xt_CHECKSUM" "xt_MASQUERADE" ]
      ++ optionals (!config.networking.nftables.enable) [ "iptable_mangle" ];
  };
}
