{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation.incus;
  preseedFormat = pkgs.formats.yaml { };

  serverBinPath = ''/run/wrappers/bin:${pkgs.qemu_kvm}/libexec:${
    lib.makeBinPath (
      with pkgs;
      [
        cfg.package

        acl
        attr
        bash
        btrfs-progs
        cdrkit
        coreutils
        criu
        dnsmasq
        e2fsprogs
        findutils
        getent
        gnugrep
        gnused
        gnutar
        gptfdisk
        gzip
        iproute2
        iptables
        iw
        kmod
        libnvidia-container
        libxfs
        lvm2
        minio
        minio-client
        nftables
        qemu-utils
        qemu_kvm
        rsync
        squashfs-tools-ng
        squashfsTools
        sshfs
        swtpm
        systemd
        thin-provisioning-tools
        util-linux
        virtiofsd
        xdelta
        xz
      ]
      ++ lib.optionals (lib.versionAtLeast cfg.package.version "6.3.0") [
        skopeo
        umoci
      ]
      ++ lib.optionals config.security.apparmor.enable [
        apparmor-bin-utils

        (writeShellScriptBin "apparmor_parser" ''
          exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
        '')
      ]
      ++ lib.optionals config.services.ceph.client.enable [ ceph-client ]
      ++ lib.optionals config.virtualisation.vswitch.enable [ config.virtualisation.vswitch.package ]
      ++ lib.optionals config.boot.zfs.enabled [
        config.boot.zfs.package
        "${config.boot.zfs.package}/lib/udev"
      ]
    )
  }'';

  # https://github.com/lxc/incus/blob/cff35a29ee3d7a2af1f937cbb6cf23776941854b/internal/server/instance/drivers/driver_qemu.go#L123
  OVMF2MB = pkgs.OVMF.override {
    secureBoot = true;
    fdSize2MB = true;
  };
  ovmf-prefix = if pkgs.stdenv.hostPlatform.isAarch64 then "AAVMF" else "OVMF";
  ovmf = pkgs.linkFarm "incus-ovmf" [
    # 2MB must remain the default or existing VMs will fail to boot. New VMs will prefer 4MB
    {
      name = "OVMF_CODE.fd";
      path = "${OVMF2MB.fd}/FV/${ovmf-prefix}_CODE.fd";
    }
    {
      name = "OVMF_VARS.fd";
      path = "${OVMF2MB.fd}/FV/${ovmf-prefix}_VARS.fd";
    }
    {
      name = "OVMF_VARS.ms.fd";
      path = "${OVMF2MB.fd}/FV/${ovmf-prefix}_VARS.fd";
    }

    {
      name = "OVMF_CODE.4MB.fd";
      path = "${pkgs.OVMFFull.fd}/FV/${ovmf-prefix}_CODE.fd";
    }
    {
      name = "OVMF_VARS.4MB.fd";
      path = "${pkgs.OVMFFull.fd}/FV/${ovmf-prefix}_VARS.fd";
    }
    {
      name = "OVMF_VARS.4MB.ms.fd";
      path = "${pkgs.OVMFFull.fd}/FV/${ovmf-prefix}_VARS.fd";
    }
  ];

  environment = lib.mkMerge [
    {
      INCUS_LXC_TEMPLATE_CONFIG = "${pkgs.lxcfs}/share/lxc/config";
      INCUS_USBIDS_PATH = "${pkgs.hwdata}/share/hwdata/usb.ids";
      PATH = lib.mkForce serverBinPath;
    }
    (lib.mkIf (lib.versionOlder cfg.package.version "6.3.0") { INCUS_OVMF_PATH = ovmf; })
    (lib.mkIf (lib.versionAtLeast cfg.package.version "6.3.0") { INCUS_EDK2_PATH = ovmf; })
    (lib.mkIf (cfg.ui.enable) { "INCUS_UI" = cfg.ui.package; })
  ];

  incus-startup = pkgs.writeShellScript "incus-startup" ''
    case "$1" in
        start)
          systemctl is-active incus.service -q && exit 0
          exec incusd activateifneeded
        ;;

        stop)
          systemctl is-active incus.service -q || exit 0
          exec incusd shutdown
        ;;

        *)
          echo "unknown argument \`$1'" >&2
          exit 1
        ;;
    esac

    exit 0
  '';
in
{
  meta = {
    maintainers = lib.teams.lxc.members;
  };

  options = {
    virtualisation.incus = {
      enable = lib.mkEnableOption ''
        incusd, a daemon that manages containers and virtual machines.

        Users in the "incus-admin" group can interact with
        the daemon (e.g. to start or stop containers) using the
        {command}`incus` command line tool, among others
      '';

      package = lib.mkPackageOption pkgs "incus-lts" { };

      lxcPackage = lib.mkOption {
        type = lib.types.package;
        default = config.virtualisation.lxc.package;
        defaultText = lib.literalExpression "config.virtualisation.lxc.package";
        description = "The lxc package to use.";
      };

      clientPackage = lib.mkOption {
        type = lib.types.package;
        default = cfg.package.client;
        defaultText = lib.literalExpression "config.virtualisation.incus.package.client";
        description = "The incus client package to use. This package is added to PATH.";
      };

      softDaemonRestart = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Allow for incus.service to be stopped without affecting running instances.
        '';
      };

      preseed = lib.mkOption {
        type = lib.types.nullOr (lib.types.submodule { freeformType = preseedFormat.type; });

        default = null;

        description = ''
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

      socketActivation = lib.mkEnableOption (''
        socket-activation for starting incus.service. Enabling this option
        will stop incus.service from starting automatically on boot.
      '');

      startTimeout = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 600;
        apply = toString;
        description = ''
          Time to wait (in seconds) for incusd to become ready to process requests.
          If incusd does not reply within the configured time, `incus.service` will be
          considered failed and systemd will attempt to restart it.
        '';
      };

      ui = {
        enable = lib.mkEnableOption "(experimental) Incus UI";

        package = lib.mkPackageOption pkgs [
          "incus"
          "ui"
        ] { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          !(
            config.networking.firewall.enable
            && !config.networking.nftables.enable
            && config.virtualisation.incus.enable
          );
        message = "Incus on NixOS is unsupported using iptables. Set `networking.nftables.enable = true;`";
      }
    ];

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

    environment.systemPackages = [
      cfg.clientPackage

      # gui console support
      pkgs.spice-gtk
    ];

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

      inherit environment;

      wantedBy = lib.mkIf (!cfg.socketActivation) [ "multi-user.target" ];
      after = [
        "network-online.target"
        "lxcfs.service"
        "incus.socket"
      ] ++ lib.optionals config.virtualisation.vswitch.enable [ "ovs-vswitchd.service" ];

      requires = [
        "lxcfs.service"
        "incus.socket"
      ] ++ lib.optionals config.virtualisation.vswitch.enable [ "ovs-vswitchd.service" ];

      wants = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/incusd --group incus-admin";
        ExecStartPost = "${cfg.package}/bin/incusd waitready --timeout=${cfg.startTimeout}";
        ExecStop = lib.optionalString (!cfg.softDaemonRestart) "${cfg.package}/bin/incus admin shutdown";

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

    systemd.services.incus-startup = lib.mkIf cfg.softDaemonRestart {
      description = "Incus Instances Startup/Shutdown";

      inherit environment;

      after = [
        "incus.service"
        "incus.socket"
      ];
      requires = [ "incus.socket" ];

      serviceConfig = {
        ExecStart = "${incus-startup} start";
        ExecStop = "${incus-startup} stop";
        RemainAfterExit = true;
        TimeoutStartSec = "600s";
        TimeoutStopSec = "600s";
        Type = "oneshot";
      };
    };

    systemd.sockets.incus = {
      description = "Incus UNIX socket";
      wantedBy = [ "sockets.target" ];

      socketConfig = {
        ListenStream = "/var/lib/incus/unix.socket";
        SocketMode = "0660";
        SocketGroup = "incus-admin";
      };
    };

    systemd.services.incus-preseed = lib.mkIf (cfg.preseed != null) {
      description = "Incus initialization with preseed file";

      wantedBy = [ "incus.service" ];
      after = [ "incus.service" ];
      bindsTo = [ "incus.service" ];
      partOf = [ "incus.service" ];

      script = ''
        ${cfg.package}/bin/incus admin init --preseed <${preseedFormat.generate "incus-preseed.yaml" cfg.preseed}
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
