{ config, lib, pkgs, ... }:

let
  cfg = config.virtualisation.incus;
  preseedFormat = pkgs.formats.yaml { };
in
{
  meta = {
    maintainers = lib.teams.lxc.members;
  };

  options = {
    virtualisation.incus = {
      enable = lib.mkEnableOption (lib.mdDoc ''
        incusd, a daemon that manages containers and virtual machines.

        Users in the "incus-admin" group can interact with
        the daemon (e.g. to start or stop containers) using the
        {command}`incus` command line tool, among others.
      '');

      package = lib.mkPackageOption pkgs "incus" { };

      lxcPackage = lib.mkPackageOption pkgs "lxc" { };

      preseed = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.submodule { freeformType = preseedFormat.type; }
        );

        default = null;

        description = lib.mdDoc ''
          Configuration for Incus preseed, see
          <https://linuxcontainers.org/incus/docs/main/howto/initialize/#non-interactive-configuration>
          for supported values.

          Changes to this will be re-applied to Incus which will overwrite existing entities or create missing ones,
          but entities will *not* be removed by preseed.
        '';

        example = {
          networks = [
            {
              name = "incusbr0";
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
                  network = "incusbr0";
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
                source = "/var/lib/incus/storage-pools/default";
              };
            }
          ];
        };
      };

      socketActivation = lib.mkEnableOption (
        lib.mdDoc ''
          socket-activation for starting incus.service. Enabling this option
          will stop incus.service from starting automatically on boot.
        ''
      );

      startTimeout = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 600;
        apply = toString;
        description = lib.mdDoc ''
          Time to wait (in seconds) for incusd to become ready to process requests.
          If incusd does not reply within the configured time, `incus.service` will be
          considered failed and systemd will attempt to restart it.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/lxc/incus/blob/f145309929f849b9951658ad2ba3b8f10cbe69d1/doc/reference/server_settings.md
    boot.kernel.sysctl = {
      "fs.aio-max-nr" = lib.mkDefault 524288;
      "fs.inotify.max_queued_events" = lib.mkDefault 1048576;
      "fs.inotify.max_user_instances" = lib.mkOverride 1050 1048576; # override in case conflict nixos/modules/services/x11/xserver.nix
      "fs.inotify.max_user_watches" = lib.mkOverride 1050 1048576; # override in case conflict nixos/modules/services/x11/xserver.nix
      "kernel.dmesg_restrict" = lib.mkDefault 1;
      "kernel.keys.maxbytes" = lib.mkDefault 2000000;
      "kernel.keys.maxkeys" = lib.mkDefault 2000;
      "net.core.bpf_jit_limit" = lib.mkDefault 1000000000;
      "net.ipv4.neigh.default.gc_thresh3" = lib.mkDefault 8192;
      "net.ipv6.neigh.default.gc_thresh3" = lib.mkDefault 8192;
      # vm.max_map_count is set higher in nixos/modules/config/sysctl.nix
    };

    boot.kernelModules = [
      "veth"
      "xt_comment"
      "xt_CHECKSUM"
      "xt_MASQUERADE"
      "vhost_vsock"
    ] ++ lib.optionals (!config.networking.nftables.enable) [ "iptable_mangle" ];

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

    systemd.services.incus = {
      description = "Incus Container and Virtual Machine Management Daemon";

      wantedBy = lib.mkIf (!cfg.socketActivation) [ "multi-user.target" ];
      after = [
        "network-online.target"
        "lxcfs.service"
      ] ++ (lib.optional cfg.socketActivation "incus.socket");
      requires = [
        "lxcfs.service"
      ] ++ (lib.optional cfg.socketActivation "incus.socket");
      wants = [
        "network-online.target"
      ];

      path = lib.mkIf config.boot.zfs.enabled [ config.boot.zfs.package ];

      environment = {
        # Override Path to the LXC template configuration directory
        INCUS_LXC_TEMPLATE_CONFIG = "${pkgs.lxcfs}/share/lxc/config";
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/incusd --group incus-admin";
        ExecStartPost = "${cfg.package}/bin/incusd waitready --timeout=${cfg.startTimeout}";
        ExecStop = "${cfg.package}/bin/incus admin shutdown";

        KillMode = "process"; # when stopping, leave the containers alone
        Delegate = "yes";
        LimitMEMLOCK = "infinity";
        LimitNOFILE = "1048576";
        LimitNPROC = "infinity";
        TasksMax = "infinity";

        Restart = "on-failure";
        TimeoutStartSec = "${cfg.startTimeout}s";
        TimeoutStopSec = "30s";
      };
    };

    systemd.sockets.incus = lib.mkIf cfg.socketActivation {
      description = "Incus UNIX socket";
      wantedBy = [ "sockets.target" ];

      socketConfig = {
        ListenStream = "/var/lib/incus/unix.socket";
        SocketMode = "0660";
        SocketGroup = "incus-admin";
        Service = "incus.service";
      };
    };

    systemd.services.incus-preseed = lib.mkIf (cfg.preseed != null) {
      description = "Incus initialization with preseed file";

      wantedBy = ["incus.service"];
      after = ["incus.service"];
      bindsTo = ["incus.service"];
      partOf = ["incus.service"];

      script = ''
        ${cfg.package}/bin/incus admin init --preseed <${
          preseedFormat.generate "incus-preseed.yaml" cfg.preseed
        }
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    users.groups.incus-admin = { };

    users.users.root = {
      # match documented default ranges https://linuxcontainers.org/incus/docs/main/userns-idmap/#allowed-ranges
      subUidRanges = [
        {
          startUid = 1000000;
          count = 1000000000;
        }
      ];
      subGidRanges = [
        {
          startGid = 1000000;
          count = 1000000000;
        }
      ];
    };

    virtualisation.lxc.lxcfs.enable = true;
  };
}
