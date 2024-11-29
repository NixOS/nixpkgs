# Xen Project Hypervisor (Dom0) support.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (builtins) readFile;
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

  xenBootBuilder = pkgs.writeShellApplication {
    name = "xenBootBuilder";
    runtimeInputs =
      (with pkgs; [
        binutils
        coreutils
        findutils
        gawk
        gnugrep
        gnused
        jq
      ])
      ++ optionals (cfg.efi.bootBuilderVerbosity == "info") (
        with pkgs;
        [
          bat
          diffutils
        ]
      );
    runtimeEnv = {
      efiMountPoint = config.boot.loader.efi.efiSysMountPoint;
    };

    # We disable SC2016 because we don't want to expand the regexes in the sed commands.
    excludeShellChecks = [ "SC2016" ];

    text = readFile ./xen-boot-builder.sh;
  };
in

{
  imports = [
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
    (mkRenamedOptionModule
      [
        "virtualisation"
        "xen"
        "stored"
      ]
      [
        "virtualisation"
        "xen"
        "store"
        "path"
      ]
    )
  ];

  ## Interface ##

  options.virtualisation.xen = {

    enable = mkEnableOption "the Xen Project Hypervisor, a virtualisation technology defined as a *type-1 hypervisor*, which allows multiple virtual machines, known as *domains*, to run concurrently on the physical machine. NixOS runs as the privileged *Domain 0*. This option requires a reboot into a Xen kernel to take effect";

    debug = mkEnableOption "Xen debug features for Domain 0. This option enables some hidden debugging tests and features, and should not be used in production";

    trace = mkOption {
      type = bool;
      default = cfg.debug;
      defaultText = literalExpression "false";
      example = true;
      description = "Whether to enable Xen debug tracing and logging for Domain 0.";
    };

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

    bootParams = mkOption {
      default = [ ];
      example = ''
        [
          "iommu=force:true,qinval:true,debug:true"
          "noreboot=true"
          "vga=ask"
        ]
      '';
      type = listOf str;
      description = ''
        Xen Command Line parameters passed to Domain 0 at boot time.
        Note: these are different from `boot.kernelParams`. See
        the [Xen documentation](https://xenbits.xenproject.org/docs/unstable/misc/xen-command-line.html) for more information.
      '';
    };

    efi = {
      bootBuilderVerbosity = mkOption {
        type = enum [
          "default"
          "info"
          "debug"
          "quiet"
        ];
        default = "default";
        example = "info";
        description = ''
          The EFI boot entry builder script should be called with exactly one of the following arguments in order to specify its verbosity:

          - `quiet` supresses all messages.

          - `default` adds a simple "Installing Xen Project Hypervisor boot entries...done." message to the script.

          - `info` is the same as `default`, but it also prints a diff with information on which generations were altered.
            - This option adds two extra dependencies to the script: `diffutils` and `bat`.

          - `debug` prints information messages for every single step of the script.

          This option does not alter the actual functionality of the script, just the number of messages printed when rebuilding the system.
        '';
      };

      path = mkOption {
        type = path;
        default = "${cfg.package.boot}/${cfg.package.efi}";
        defaultText = literalExpression "\${config.virtualisation.xen.package.boot}/\${config.virtualisation.xen.package.efi}";
        example = literalExpression "\${config.virtualisation.xen.package}/boot/efi/efi/nixos/xen-\${config.virtualisation.xen.package.version}.efi";
        description = ''
          Path to xen.efi. `pkgs.xen` is patched to install the xen.efi file
          on `$boot/boot/xen.efi`, but an unpatched Xen build may install it
          somewhere else, such as `$out/boot/efi/efi/nixos/xen.efi`. Unless
          you're building your own Xen derivation, you should leave this
          option as the default value.
        '';
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

    store = {
      path = mkOption {
        type = path;
        default = "${cfg.package}/bin/oxenstored";
        defaultText = literalExpression "\${config.virtualisation.xen.package}/bin/oxenstored";
        example = literalExpression "\${config.virtualisation.xen.package}/bin/xenstored";
        description = ''
          Path to the Xen Store Daemon. This option is useful to
          switch between the legacy C-based Xen Store Daemon, and
          the newer OCaml-based Xen Store Daemon, `oxenstored`.
        '';
      };
      type = mkOption {
        type = enum [
          "c"
          "ocaml"
        ];
        default = if (hasSuffix "oxenstored" cfg.store.path) then "ocaml" else "c";
        internal = true;
        readOnly = true;
        description = "Helper internal option that determines the type of the Xen Store Daemon based on cfg.store.path.";
      };
      settings = mkOption {
        default = { };
        example = {
          enableMerge = false;
          quota.maxWatchEvents = 2048;
          quota.enable = true;
          conflict.maxHistorySeconds = 0.12;
          conflict.burstLimit = 15.0;
          xenstored.log.file = "/dev/null";
          xenstored.log.level = "info";
        };
        description = ''
          The OCaml-based Xen Store Daemon configuration. This
          option does nothing with the C-based `xenstored`.
        '';
        type = submodule {
          options = {
            pidFile = mkOption {
              default = "/run/xen/xenstored.pid";
              example = "/var/run/xen/xenstored.pid";
              type = path;
              description = "Path to the Xen Store Daemon PID file.";
            };
            testEAGAIN = mkOption {
              default = cfg.debug;
              defaultText = literalExpression "config.virtualisation.xen.debug";
              example = true;
              type = bool;
              visible = false;
              description = "Randomly fail a transaction with EAGAIN. This option is used for debugging purposes only.";
            };
            enableMerge = mkOption {
              default = true;
              example = false;
              type = bool;
              description = "Whether to enable transaction merge support.";
            };
            conflict = {
              burstLimit = mkOption {
                default = 5.0;
                example = 15.0;
                type = addCheck (
                  float
                  // {
                    name = "nonnegativeFloat";
                    description = "nonnegative floating point number, meaning >=0";
                    descriptionClass = "nonRestrictiveClause";
                  }
                ) (n: n >= 0);
                description = ''
                  Limits applied to domains whose writes cause other domains' transaction
                  commits to fail. Must include decimal point.

                  The burst limit is the number of conflicts a domain can cause to
                  fail in a short period; this value is used for both the initial and
                  the maximum value of each domain's conflict-credit, which falls by
                  one point for each conflict caused, and when it reaches zero the
                  domain's requests are ignored.
                '';
              };
              maxHistorySeconds = mkOption {
                default = 5.0e-2;
                example = 1.0;
                type = addCheck (float // { description = "nonnegative floating point number, meaning >=0"; }) (
                  n: n >= 0
                );
                description = ''
                  Limits applied to domains whose writes cause other domains' transaction
                  commits to fail. Must include decimal point.

                  The conflict-credit is replenished over time:
                  one point is issued after each conflict.maxHistorySeconds, so this
                  is the minimum pause-time during which a domain will be ignored.
                '';
              };
              rateLimitIsAggregate = mkOption {
                default = true;
                example = false;
                type = bool;
                description = ''
                  If the conflict.rateLimitIsAggregate option is `true`, then after each
                  tick one point of conflict-credit is given to just one domain: the
                  one at the front of the queue. If `false`, then after each tick each
                  domain gets a point of conflict-credit.

                  In environments where it is known that every transaction will
                  involve a set of nodes that is writable by at most one other domain,
                  then it is safe to set this aggregate limit flag to `false` for better
                  performance. (This can be determined by considering the layout of
                  the xenstore tree and permissions, together with the content of the
                  transactions that require protection.)

                  A transaction which involves a set of nodes which can be modified by
                  multiple other domains can suffer conflicts caused by any of those
                  domains, so the flag must be set to `true`.
                '';
              };
            };
            perms = {
              enable = mkOption {
                default = true;
                example = false;
                type = bool;
                description = "Whether to enable the node permission system.";
              };
              enableWatch = mkOption {
                default = true;
                example = false;
                type = bool;
                description = ''
                  Whether to enable the watch permission system.

                  When this is set to `true`, unprivileged guests can only get watch events
                  for xenstore entries that they would've been able to read.

                  When this is set to `false`, unprivileged guests may get watch events
                  for xenstore entries that they cannot read. The watch event contains
                  only the entry name, not the value.
                  This restores behaviour prior to [XSA-115](https://xenbits.xenproject.org/xsa/advisory-115.html).
                '';
              };
            };
            quota = {
              enable = mkOption {
                default = true;
                example = false;
                type = bool;
                description = "Whether to enable the quota system.";
              };
              maxEntity = mkOption {
                default = 1000;
                example = 1024;
                type = ints.positive;
                description = "Entity limit for transactions.";
              };
              maxSize = mkOption {
                default = 2048;
                example = 4096;
                type = ints.positive;
                description = "Size limit for transactions.";
              };
              maxWatch = mkOption {
                default = 100;
                example = 256;
                type = ints.positive;
                description = "Maximum number of watches by the Xenstore Watchdog.";
              };
              transaction = mkOption {
                default = 10;
                example = 50;
                type = ints.positive;
                description = "Maximum number of transactions.";
              };
              maxRequests = mkOption {
                default = 1024;
                example = 1024;
                type = ints.positive;
                description = "Maximum number of requests per transaction.";
              };
              maxPath = mkOption {
                default = 1024;
                example = 1024;
                type = ints.positive;
                description = "Path limit for the quota system.";
              };
              maxOutstanding = mkOption {
                default = 1024;
                example = 1024;
                type = ints.positive;
                description = "Maximum outstanding requests, i.e. in-flight requests / domain.";
              };
              maxWatchEvents = mkOption {
                default = 1024;
                example = 2048;
                type = ints.positive;
                description = "Maximum number of outstanding watch events per watch.";
              };
            };
            persistent = mkOption {
              default = false;
              example = true;
              type = bool;
              description = "Whether to activate the filed base backend.";
            };
            xenstored = {
              log = {
                file = mkOption {
                  default = "/var/log/xen/xenstored.log";
                  example = "/dev/null";
                  type = path;
                  description = "Path to the Xen Store log file.";
                };
                level = mkOption {
                  default = if cfg.trace then "debug" else null;
                  defaultText = literalExpression "if (config.virtualisation.xen.trace == true) then \"debug\" else null";
                  example = "error";
                  type = nullOr (enum [
                    "debug"
                    "info"
                    "warn"
                    "error"
                  ]);
                  description = "Logging level for the Xen Store.";
                };
                # The hidden options below have no upstream documentation whatsoever.
                # The nb* options appear to alter the log rotation behaviour, and
                # the specialOps option appears to affect the Xenbus logging logic.
                nbFiles = mkOption {
                  default = 10;
                  example = 16;
                  type = int;
                  visible = false;
                  description = "Set `xenstored-log-nb-files`.";
                };
              };
              accessLog = {
                file = mkOption {
                  default = "/var/log/xen/xenstored-access.log";
                  example = "/var/log/security/xenstored-access.log";
                  type = path;
                  description = "Path to the Xen Store access log file.";
                };
                nbLines = mkOption {
                  default = 13215;
                  example = 16384;
                  type = int;
                  visible = false;
                  description = "Set `access-log-nb-lines`.";
                };
                nbChars = mkOption {
                  default = 180;
                  example = 256;
                  type = int;
                  visible = false;
                  description = "Set `acesss-log-nb-chars`.";
                };
                specialOps = mkOption {
                  default = false;
                  example = true;
                  type = bool;
                  visible = false;
                  description = "Set `access-log-special-ops`.";
                };
              };
              xenfs = {
                kva = mkOption {
                  default = "/proc/xen/xsd_kva";
                  example = cfg.store.settings.xenstored.xenfs.kva;
                  type = path;
                  visible = false;
                  description = ''
                    Path to the Xen Store Daemon KVA location inside the XenFS pseudo-filesystem.
                    While it is possible to alter this value, some drivers may be hardcoded to follow the default paths.
                  '';
                };
                port = mkOption {
                  default = "/proc/xen/xsd_port";
                  example = cfg.store.settings.xenstored.xenfs.port;
                  type = path;
                  visible = false;
                  description = ''
                    Path to the Xen Store Daemon userspace port inside the XenFS pseudo-filesystem.
                    While it is possible to alter this value, some drivers may be hardcoded to follow the default paths.
                  '';
                };
              };
            };
            ringScanInterval = mkOption {
              default = 20;
              example = 30;
              type = addCheck (
                int
                // {
                  name = "nonzeroInt";
                  description = "nonzero signed integer, meaning !=0";
                  descriptionClass = "nonRestrictiveClause";
                }
              ) (n: n != 0);
              description = ''
                Perodic scanning for all the rings as a safenet for lazy clients.
                Define the interval in seconds; set to a negative integer to disable.
              '';
            };
          };
        };
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
        assertion =
          config.boot.loader.systemd-boot.enable
          || (config.boot ? lanzaboote) && config.boot.lanzaboote.enable;
        message = "Xen only supports booting on systemd-boot or Lanzaboote.";
      }
      {
        assertion = config.boot.initrd.systemd.enable;
        message = "Xen does not support the legacy script-based Stage 1 initrd.";
      }
      {
        assertion = cfg.dom0Resources.maxMemory >= cfg.dom0Resources.memory;
        message = ''
          You have allocated more memory to dom0 than virtualisation.xen.dom0Resources.maxMemory
          allows for. Please increase the maximum memory limit, or decrease the default memory allocation.
        '';
      }
      {
        assertion = cfg.debug -> cfg.trace;
        message = "Xen's debugging features are enabled, but logging is disabled. This is most likely not what you want.";
      }
      {
        assertion = cfg.store.settings.quota.maxWatchEvents >= cfg.store.settings.quota.maxOutstanding;
        message = ''
          Upstream Xen recommends that maxWatchEvents be equal to or greater than maxOutstanding,
          in order to mitigate denial of service attacks from malicious frontends.
        '';
      }
    ];

    virtualisation.xen.bootParams =
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

      # Xen Bootspec extension. This extension allows NixOS bootloaders to
      # fetch the `xen.efi` path and access the `cfg.bootParams` option.
      bootspec.extensions = {
        "org.xenproject.bootspec.v1" = {
          xen = cfg.efi.path;
          xenParams = cfg.bootParams;
        };
      };

      # See the `xenBootBuilder` script in the main `let...in` statement of this file.
      loader.systemd-boot.extraInstallCommands = ''
        ${getExe xenBootBuilder} ${cfg.efi.bootBuilderVerbosity}
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
        cfg.qemu.package
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
        }
        # The OCaml-based Xen Store Daemon requires /etc/xen/oxenstored.conf to start.
        // optionalAttrs (cfg.store.type == "ocaml") {
          "xen/oxenstored.conf".text = ''
            pid-file = ${cfg.store.settings.pidFile}
            test-eagain = ${boolToString cfg.store.settings.testEAGAIN}
            merge-activate = ${toString cfg.store.settings.enableMerge}
            conflict-burst-limit = ${toString cfg.store.settings.conflict.burstLimit}
            conflict-max-history-seconds = ${toString cfg.store.settings.conflict.maxHistorySeconds}
            conflict-rate-limit-is-aggregate = ${toString cfg.store.settings.conflict.rateLimitIsAggregate}
            perms-activate = ${toString cfg.store.settings.perms.enable}
            perms-watch-activate = ${toString cfg.store.settings.perms.enableWatch}
            quota-activate = ${toString cfg.store.settings.quota.enable}
            quota-maxentity = ${toString cfg.store.settings.quota.maxEntity}
            quota-maxsize = ${toString cfg.store.settings.quota.maxSize}
            quota-maxwatch = ${toString cfg.store.settings.quota.maxWatch}
            quota-transaction = ${toString cfg.store.settings.quota.transaction}
            quota-maxrequests = ${toString cfg.store.settings.quota.maxRequests}
            quota-path-max = ${toString cfg.store.settings.quota.maxPath}
            quota-maxoutstanding = ${toString cfg.store.settings.quota.maxOutstanding}
            quota-maxwatchevents = ${toString cfg.store.settings.quota.maxWatchEvents}
            persistent = ${boolToString cfg.store.settings.persistent}
            xenstored-log-file = ${cfg.store.settings.xenstored.log.file}
            xenstored-log-level = ${
              if isNull cfg.store.settings.xenstored.log.level then
                "null"
              else
                cfg.store.settings.xenstored.log.level
            }
            xenstored-log-nb-files = ${toString cfg.store.settings.xenstored.log.nbFiles}
            access-log-file = ${cfg.store.settings.xenstored.accessLog.file}
            access-log-nb-lines = ${toString cfg.store.settings.xenstored.accessLog.nbLines}
            acesss-log-nb-chars = ${toString cfg.store.settings.xenstored.accessLog.nbChars}
            access-log-special-ops = ${boolToString cfg.store.settings.xenstored.accessLog.specialOps}
            ring-scan-interval = ${toString cfg.store.settings.ringScanInterval}
            xenstored-kva = ${cfg.store.settings.xenstored.xenfs.kva}
            xenstored-port = ${cfg.store.settings.xenstored.xenfs.port}
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
