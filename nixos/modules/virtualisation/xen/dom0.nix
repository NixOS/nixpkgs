# Xen Project Hypervisor (Dom0) support.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (builtins) readFile;
  inherit (lib.meta) hiPrio;
  inherit (lib.modules) mkRemovedOptionModule mkRenamedOptionModule mkIf;
  inherit (lib.options)
    mkOption
    mkEnableOption
    literalExpression
    mkPackageOption
    ;
  inherit (lib.types)
    listOf
    str
    ints
    lines
    enum
    path
    submodule
    addCheck
    float
    bool
    int
    nullOr
    ;
  inherit (lib.lists) optional optionals;
  inherit (lib.strings) hasSuffix optionalString;
  inherit (lib.meta) getExe;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.trivial) boolToString;
  inherit (lib.teams.xen) members;

  cfg = config.virtualisation.xen;
in
{
  imports = [
    ./oxenstored.nix
    ./efi.nix
    (mkRemovedOptionModule
      [
        "virtualisation"
        "xen"
        "bridge"
        "name"
      ]
      "The Xen Network Bridge options are currently unavailable. Please set up your own bridge manually."
    )
    (mkRemovedOptionModule
      [
        "virtualisation"
        "xen"
        "bridge"
        "address"
      ]
      "The Xen Network Bridge options are currently unavailable. Please set up your own bridge manually."
    )
    (mkRemovedOptionModule
      [
        "virtualisation"
        "xen"
        "bridge"
        "prefixLength"
      ]
      "The Xen Network Bridge options are currently unavailable. Please set up your own bridge manually."
    )
    (mkRemovedOptionModule
      [
        "virtualisation"
        "xen"
        "bridge"
        "forwardDns"
      ]
      "The Xen Network Bridge options are currently unavailable. Please set up your own bridge manually."
    )
    (mkRenamedOptionModule
      [
        "virtualisation"
        "xen"
        "qemu-package"
      ]
      [
        "virtualisation"
        "xen"
        "qemu"
        "package"
      ]
    )
    (mkRenamedOptionModule
      [
        "virtualisation"
        "xen"
        "package-qemu"
      ]
      [
        "virtualisation"
        "xen"
        "qemu"
        "package"
      ]
    )
  ];

  ## Interface ##

  options.virtualisation.xen = {

    enable = mkEnableOption "the Xen Project Hypervisor, a virtualisation technology defined as a *type-1 hypervisor*, which allows multiple virtual machines, known as *domains*, to run concurrently on the physical machine. NixOS runs as the privileged *Domain 0*. This option requires a reboot into a Xen kernel to take effect";

    trace = mkEnableOption "Xen debug tracing and logging for Domain 0";

    package = mkPackageOption pkgs "Xen Hypervisor" { default = [ "xen" ]; };

    qemu = {
      package = mkPackageOption pkgs "QEMU (with Xen Hypervisor support)" {
        default = [ "qemu_xen" ];
      };
      pidFile = mkOption {
        type = path;
        default = "/run/xen/qemu-dom0.pid";
        example = "/var/run/xen/qemu-dom0.pid";
        description = "Path to the QEMU PID file.";
      };
    };

    dom0Resources = {
      maxVCPUs = mkOption {
        default = 0;
        example = 4;
        type = ints.unsigned;
        description = ''
          Amount of virtual CPU cores allocated to Domain 0 on boot.
          If set to 0, all cores are assigned to Domain 0, and
          unprivileged domains will compete with Domain 0 for CPU time.
        '';
      };

      memory = mkOption {
        default = 0;
        example = 512;
        type = ints.unsigned;
        description = ''
          Amount of memory (in MiB) allocated to Domain 0 on boot.
          If set to 0, all memory is assigned to Domain 0, and
          unprivileged domains will compete with Domain 0 for free RAM.
        '';
      };

      maxMemory = mkOption {
        default = cfg.dom0Resources.memory;
        defaultText = literalExpression "config.virtualisation.xen.dom0Resources.memory";
        example = 1024;
        type = ints.unsigned;
        description = ''
          Maximum amount of memory (in MiB) that Domain 0 can
          dynamically allocate to itself. Does nothing if set
          to the same amount as virtualisation.xen.memory, or
          if that option is set to 0.
        '';
      };
    };

    domains = {
      extraConfig = mkOption {
        type = lines;
        default = "";
        example = ''
          XENDOMAINS_SAVE=/persist/xen/save
          XENDOMAINS_RESTORE=false
          XENDOMAINS_CREATE_USLEEP=10000000
        '';
        description = ''
          Options defined here will override the defaults for xendomains.
          The default options can be seen in the file included from
          /etc/default/xendomains.
        '';
      };
    };
  };

  ## Implementation ##

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isx86_64;
        message = "Xen is currently not supported on ${pkgs.stdenv.hostPlatform.system}.";
      }
      {
        assertion = cfg.dom0Resources.maxMemory >= cfg.dom0Resources.memory;
        message = ''
          You have allocated more memory to dom0 than virtualisation.xen.dom0Resources.maxMemory
          allows for. Please increase the maximum memory limit, or decrease the default memory allocation.
        '';
      }
    ];

    virtualisation.xen.boot.params =
      optionals cfg.trace [
        "loglvl=all"
        "guest_loglvl=all"
      ]
      ++
        optional (cfg.dom0Resources.memory != 0)
          "dom0_mem=${toString cfg.dom0Resources.memory}M${
            optionalString (
              cfg.dom0Resources.memory != cfg.dom0Resources.maxMemory
            ) ",max:${toString cfg.dom0Resources.maxMemory}M"
          }"
      ++ optional (
        cfg.dom0Resources.maxVCPUs != 0
      ) "dom0_max_vcpus=${toString cfg.dom0Resources.maxVCPUs}";

    boot = {
      kernelModules = [
        "xen-evtchn"
        "xen-gntdev"
        "xen-gntalloc"
        "xen-blkback"
        "xen-netback"
        "xen-pciback"
        "evtchn"
        "gntdev"
        "netbk"
        "blkbk"
        "xen-scsibk"
        "usbbk"
        "pciback"
        "xen-acpi-processor"
        "blktap2"
        "tun"
        "netxen_nic"
        "xen_wdt"
        "xen-acpi-processor"
        "xen-privcmd"
        "xen-scsiback"
        "xenfs"
      ];

      # The xenfs module is needed to mount /proc/xen.
      initrd.kernelModules = [ "xenfs" ];

      # Increase the number of loopback devices from the default (8),
      # which is way too small because every VM virtual disk requires a
      # loopback device.
      extraModprobeConfig = ''
        options loop max_loop=64
      '';
    };

    # Domain 0 requires a pvops-enabled kernel.
    # All NixOS kernels come with this enabled by default; this is merely a sanity check.
    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "XEN")
      (isYes "X86_IO_APIC")
      (isYes "ACPI")
      (isYes "XEN_DOM0")
      (isYes "PCI_XEN")
      (isYes "XEN_DEV_EVTCHN")
      (isYes "XENFS")
      (isYes "XEN_COMPAT_XENFS")
      (isYes "XEN_SYS_HYPERVISOR")
      (isYes "XEN_GNTDEV")
      (isYes "XEN_BACKEND")
      (isModule "XEN_NETDEV_BACKEND")
      (isModule "XEN_BLKDEV_BACKEND")
      (isModule "XEN_PCIDEV_BACKEND")
      (isYes "XEN_BALLOON")
      (isYes "XEN_SCRUB_PAGES")
    ];

    environment = {
      systemPackages = [
        cfg.package
        (hiPrio cfg.qemu.package)
      ];
      etc =
        # Set up Xen Domain 0 configuration files.
        {
          "xen/xl.conf".source = "${cfg.package}/etc/xen/xl.conf"; # TODO: Add options to configure xl.conf declaratively. It's worth considering making a new "xl value" type, as it could be reused to produce xl.cfg (domain definition) files.
          "xen/scripts-xen" = {
            source = "${cfg.package}/etc/xen/scripts/*";
            target = "xen/scripts";
          };
          "default/xencommons".text = ''
            source ${cfg.package}/etc/default/xencommons

            XENSTORED="${cfg.store.path}"
            QEMU_XEN="${cfg.qemu.package}/${cfg.qemu.package.qemu-system-i386}"
            ${optionalString cfg.trace ''
              XENSTORED_TRACE=yes
              XENCONSOLED_TRACE=all
            ''}
          '';
          "default/xendomains".text = ''
            source ${cfg.package}/etc/default/xendomains

            ${cfg.domains.extraConfig}
          '';
        };
    };

    # Xen provides udev rules.
    services.udev.packages = [ cfg.package ];

    systemd = {
      # Xen provides systemd units.
      packages = [ cfg.package ];

      mounts = [
        {
          description = "Mount /proc/xen files";
          what = "xenfs";
          where = "/proc/xen";
          type = "xenfs";
          unitConfig = {
            ConditionPathExists = "/proc/xen";
            RefuseManualStop = "true";
          };
        }
      ];

      services = {

        # While this service is installed by the `xen` package, it shouldn't be used in dom0.
        xendriverdomain.enable = false;

        xenstored = {
          wantedBy = [ "multi-user.target" ];
          preStart = ''
            export XENSTORED_ROOTDIR="/var/lib/xenstored"
            rm -f "$XENSTORED_ROOTDIR"/tdb* &>/dev/null
            mkdir -p /var/{run,log,lib}/xen
          '';
        };

        xen-init-dom0 = {
          restartIfChanged = false;
          wantedBy = [ "multi-user.target" ];
        };

        xen-qemu-dom0-disk-backend = {
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            PIDFile = cfg.qemu.pidFile;
            ExecStart = ''
              ${cfg.qemu.package}/${cfg.qemu.package.qemu-system-i386} \
              -xen-domid 0 -xen-attach -name dom0 -nographic -M xenpv \
              -daemonize -monitor /dev/null -serial /dev/null -parallel \
              /dev/null -nodefaults -no-user-config -pidfile \
              ${cfg.qemu.pidFile}
            '';
          };
        };

        xenconsoled.wantedBy = [ "multi-user.target" ];

        xen-watchdog = {
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            RestartSec = "1";
            Restart = "on-failure";
          };
        };

        xendomains = {
          restartIfChanged = false;
          path = [
            cfg.package
            cfg.qemu.package
          ];
          preStart = "mkdir -p /var/lock/subsys -m 755";
          wantedBy = [ "multi-user.target" ];
        };
      };
    };
  };
  meta.maintainers = members;
}
