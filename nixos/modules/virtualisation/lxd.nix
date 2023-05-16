# Systemd services for lxd.

{ config, lib, pkgs, ... }:

<<<<<<< HEAD
let
  cfg = config.virtualisation.lxd;
  preseedFormat = pkgs.formats.yaml {};
in {
  imports = [
    (lib.mkRemovedOptionModule [ "virtualisation" "lxd" "zfsPackage" ] "Override zfs in an overlay instead to override it globally")
=======
with lib;

let
  cfg = config.virtualisation.lxd;
in {
  imports = [
    (mkRemovedOptionModule [ "virtualisation" "lxd" "zfsPackage" ] "Override zfs in an overlay instead to override it globally")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  ###### interface

  options = {
    virtualisation.lxd = {
<<<<<<< HEAD
      enable = lib.mkOption {
        type = lib.types.bool;
=======
      enable = mkOption {
        type = types.bool;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        default = false;
        description = lib.mdDoc ''
          This option enables lxd, a daemon that manages
          containers. Users in the "lxd" group can interact with
          the daemon (e.g. to start or stop containers) using the
          {command}`lxc` command line tool, among others.

          Most of the time, you'll also want to start lxcfs, so
          that containers can "see" the limits:
          ```
          virtualisation.lxc.lxcfs.enable = true;
          ```
        '';
      };

<<<<<<< HEAD
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.lxd;
        defaultText = lib.literalExpression "pkgs.lxd";
=======
      package = mkOption {
        type = types.package;
        default = pkgs.lxd;
        defaultText = literalExpression "pkgs.lxd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        description = lib.mdDoc ''
          The LXD package to use.
        '';
      };

<<<<<<< HEAD
      lxcPackage = lib.mkOption {
        type = lib.types.package;
        default = pkgs.lxc;
        defaultText = lib.literalExpression "pkgs.lxc";
=======
      lxcPackage = mkOption {
        type = types.package;
        default = pkgs.lxc;
        defaultText = literalExpression "pkgs.lxc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        description = lib.mdDoc ''
          The LXC package to use with LXD (required for AppArmor profiles).
        '';
      };

<<<<<<< HEAD
      zfsSupport = lib.mkOption {
        type = lib.types.bool;
        default = config.boot.zfs.enabled;
        defaultText = lib.literalExpression "config.boot.zfs.enabled";
=======
      zfsSupport = mkOption {
        type = types.bool;
        default = config.boot.zfs.enabled;
        defaultText = literalExpression "config.boot.zfs.enabled";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        description = lib.mdDoc ''
          Enables lxd to use zfs as a storage for containers.

          This option is enabled by default if a zfs pool is configured
          with nixos.
        '';
      };

<<<<<<< HEAD
      recommendedSysctlSettings = lib.mkOption {
        type = lib.types.bool;
=======
      recommendedSysctlSettings = mkOption {
        type = types.bool;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        default = false;
        description = lib.mdDoc ''
          Enables various settings to avoid common pitfalls when
          running containers requiring many file operations.
          Fixes errors like "Too many open files" or
          "neighbour: ndisc_cache: neighbor table overflow!".
          See https://lxd.readthedocs.io/en/latest/production-setup/
          for details.
        '';
      };

<<<<<<< HEAD
      preseed = lib.mkOption {
        type = lib.types.nullOr (lib.types.submodule {
          freeformType = preseedFormat.type;
        });

        default = null;

        description = lib.mdDoc ''
          Configuration for LXD preseed, see
          <https://documentation.ubuntu.com/lxd/en/latest/howto/initialize/#initialize-preseed>
          for supported values.

          Changes to this will be re-applied to LXD which will overwrite existing entities or create missing ones,
          but entities will *not* be removed by preseed.
        '';

        example = lib.literalExpression ''
          {
            networks = [
              {
                name = "lxdbr0";
                type = "bridge";
                config = {
                  "ipv4.address" = "10.0.100.1/24";
                  "ipv4.nat" = "true";
                };
              }
            ];
            profiles = [
              {
                name = "default";
                devices = {
                  eth0 = {
                    name = "eth0";
                    network = "lxdbr0";
                    type = "nic";
                  };
                  root = {
                    path = "/";
                    pool = "default";
                    size = "35GiB";
                    type = "disk";
                  };
                };
              }
            ];
            storage_pools = [
              {
                name = "default";
                driver = "dir";
                config = {
                  source = "/var/lib/lxd/storage-pools/default";
                };
              }
            ];
          }
        '';
      };

      startTimeout = lib.mkOption {
        type = lib.types.int;
=======
      startTimeout = mkOption {
        type = types.int;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        default = 600;
        apply = toString;
        description = lib.mdDoc ''
          Time to wait (in seconds) for LXD to become ready to process requests.
          If LXD does not reply within the configured time, lxd.service will be
          considered failed and systemd will attempt to restart it.
        '';
      };
<<<<<<< HEAD

      ui = {
        enable = lib.mkEnableOption (lib.mdDoc ''
          Enables the (experimental) LXD UI.
        '');

        package = lib.mkPackageOption pkgs.lxd-unwrapped "ui" { };
      };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  ###### implementation
<<<<<<< HEAD
  config = lib.mkIf cfg.enable {
=======
  config = mkIf cfg.enable {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
      after = [
        "network-online.target"
<<<<<<< HEAD
        (lib.mkIf config.virtualisation.lxc.lxcfs.enable "lxcfs.service")
=======
        (mkIf config.virtualisation.lxc.lxcfs.enable "lxcfs.service")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      ];
      requires = [
        "network-online.target"
        "lxd.socket"
<<<<<<< HEAD
        (lib.mkIf config.virtualisation.lxc.lxcfs.enable "lxcfs.service")
=======
        (mkIf config.virtualisation.lxc.lxcfs.enable "lxcfs.service")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      ];
      documentation = [ "man:lxd(1)" ];

      path = [ pkgs.util-linux ]
<<<<<<< HEAD
        ++ lib.optional cfg.zfsSupport config.boot.zfs.package;

      environment = lib.mkIf (cfg.ui.enable) {
        "LXD_UI" = cfg.ui.package;
      };
=======
        ++ optional cfg.zfsSupport config.boot.zfs.package;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
        Environment = lib.mkIf (config.virtualisation.lxc.lxcfs.enable)
=======
        Environment = mkIf (config.virtualisation.lxc.lxcfs.enable)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          "LXD_LXC_TEMPLATE_CONFIG=${pkgs.lxcfs}/share/lxc/config";
      };
    };

<<<<<<< HEAD
    systemd.services.lxd-preseed = lib.mkIf (cfg.preseed != null) {
      description = "LXD initialization with preseed file";
      wantedBy = ["multi-user.target"];
      requires = ["lxd.service"];
      after = ["lxd.service"];

      script = ''
        ${pkgs.coreutils}/bin/cat ${preseedFormat.generate "lxd-preseed.yaml" cfg.preseed} | ${cfg.package}/bin/lxd init --preseed
      '';

      serviceConfig = {
        Type = "oneshot";
      };
    };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    users.groups.lxd = {};

    users.users.root = {
      subUidRanges = [ { startUid = 1000000; count = 65536; } ];
      subGidRanges = [ { startGid = 1000000; count = 65536; } ];
    };

<<<<<<< HEAD
    boot.kernel.sysctl = lib.mkIf cfg.recommendedSysctlSettings {
      "fs.inotify.max_queued_events" = 1048576;
      "fs.inotify.max_user_instances" = 1048576;
      "fs.inotify.max_user_watches" = 1048576;
      "vm.max_map_count" = 262144; # TODO: Default vm.max_map_count has been increased system-wide
=======
    boot.kernel.sysctl = mkIf cfg.recommendedSysctlSettings {
      "fs.inotify.max_queued_events" = 1048576;
      "fs.inotify.max_user_instances" = 1048576;
      "fs.inotify.max_user_watches" = 1048576;
      "vm.max_map_count" = 262144;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      "kernel.dmesg_restrict" = 1;
      "net.ipv4.neigh.default.gc_thresh3" = 8192;
      "net.ipv6.neigh.default.gc_thresh3" = 8192;
      "kernel.keys.maxkeys" = 2000;
    };

<<<<<<< HEAD
    boot.kernelModules = [ "veth" "xt_comment" "xt_CHECKSUM" "xt_MASQUERADE" "vhost_vsock" ]
      ++ lib.optionals (!config.networking.nftables.enable) [ "iptable_mangle" ];
=======
    boot.kernelModules = [ "veth" "xt_comment" "xt_CHECKSUM" "xt_MASQUERADE" ]
      ++ optionals (!config.networking.nftables.enable) [ "iptable_mangle" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
