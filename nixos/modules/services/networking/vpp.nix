{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vpp;
  vpp = pkgs.vpp;

  lines = splitString "\n";
  removeEmptyLines = text: concatStringsSep "\n" (filter (line: line != "") (lines text));
  hasValue = attr: any (v: v != null) (attrValues attr);

  unixSectionConf = with cfg.unix;
    optionalString interactive ''
      interactive
    '' + optionalString nodaemon ''
      nodaemon
    '' + optionalString (log != null) ''
      log ${log}
    '' + optionalString interactive ''
      interactive
    '' + optionalString full-coredump ''
      full-coredump
    '' + optionalString cli-line-mode ''
      cli-line-mode
    '' + optionalString cli-no-banner ''
      cli-no-banner
    '' + optionalString cli-no-pager ''
      cli-no-pager
    '' + optionalString (startup-config != null) ''
      startup-config ${startup-config}
    '' + optionalString (gid != null) ''
      gid ${gid}
    '' + optionalString (coredump-size != null) ''
      coredump-size ${coredump-size}
    '' + optionalString (cli-listen != null) ''
      cli-listen ${cli-listen}
    '' + optionalString (cli-prompt != null) ''
      cli-prompt ${cli-prompt}
    '' + optionalString (cli-history-limit != null) ''
      cli-history-limit ${toString cli-history-limit}
    '' + optionalString (cli-pager-buffer-limit != null) ''
      cli-pager-buffer-limit ${toString cli-pager-buffer-limit}
    '' + optionalString (runtime-dir != null) ''
      runtime-dir ${runtime-dir}
    '' + optionalString (poll-sleep-usec != null) ''
      poll-sleep-usec ${(toString poll-sleep-usec)}
    '' + optionalString (pidfile != null) ''
      pidfile ${pidfile}'';
  unixSection =
    ''
      unix {
      ${unixSectionConf}
      }
    '';
  dpdkSectionConf = with cfg.dpdk;
    optionalString (dev != null) ''
      ${concatMapStrings (dev': ''
        dev ${dev'.name} ${optionalString (hasValue dev'.value) "{"}
        ${optionalString (dev'.value.num-rx-queues != null) ''
          num-rx-queues ${toString dev'.value.num-rx-queues}
        ''}
        ${optionalString (dev'.value.num-tx-queues != null) ''
          num-tx-queues ${toString dev'.value.num-tx-queues}
        ''}
        ${optionalString (dev'.value.num-rx-desc != null) ''
          num-rx-desc ${toString dev'.value.num-rx-desc}
        ''}
        ${optionalString (dev'.value.num-tx-desc != null) ''
          num-tx-desc ${toString dev'.value.num-tx-desc}
        ''}
        ${optionalString (dev'.value.vlan-strip-offload != null) ''
          vlan-strip-offload ${if dev'.value.vlan-strip-offload then "on" else "off"}
        ''}
        ${optionalString (dev'.value.hqos != null) ''
          hqos ${optionalString (hasValue dev'.value.hqos) "{"}
          ${optionalString (dev'.value.hqos.hqos-thread != null) ''
            hqos-thread ${toString dev'.value.hqos.hqos-thread}
          ''}
          ${optionalString (hasValue dev'.value.hqos) "}"}
        ''}
        ${optionalString (hasValue dev'.value) "}"}
      '') (mapAttrsToList (name: value: { name = name; value = value; }) dev)}
    '' + optionalString (vdev != null) ''
      ${concatMapStrings (vdev': ''
        vdev ${vdev'}
      '') vdev}
    '' + optionalString (num-mbufs != null) ''
      num-mbufs ${toString num-mbufs}
    '' + optionalString no-pci ''
      no-pci
    '' + optionalString no-hugetlb ''
      no-hugetlb
    '' + optionalString (kni != null) ''
      kni ${toString kni}
    '' + optionalString (uio-driver != null) ''
      uio-driver ${uio-driver}
    '' + optionalString (socket-mem != null) ''
      socket-mem ${toString socket-mem}
    '' + optionalString enable-tcp-udp-checksum ''
      enable-tcp-udp-checksum
    '' + optionalString no-multi-seg ''
      no-multi-seg
    '' + optionalString no-tx-checksum-offload ''
      no-tx-checksum-offload
    '' + optionalString decimal-interface-names ''
      decimal-interface-names
    '' + optionalString (log-level != null) ''
      log-level ${log-level}
    '';
  dpdkSection = ''
    dpdk {
    ${dpdkSectionConf}
    }
  '';
  cpuSectionConf = with cfg.cpu;
    optionalString (workers != null) ''
      workers ${toString workers}
    '' + optionalString (io != null) ''
      io ${toString io}
    '' + optionalString main-thread-io ''
      main-thread-io
    '' + optionalString (skip-cores != null) ''
      skip-cores ${toString skip-cores}
    '' + optionalString (main-core != null) ''
      main-core ${toString main-core}
    '' + optionalString (coremask-workers != null) ''
      coremask-workers ${coremask-workers}
    '' + optionalString (corelist-workers != null) ''
      corelist-workers ${corelist-workers}
    '' + optionalString (corelist-io != null) ''
      corelist-io ${corelist-io}
    '' + optionalString (coremask-hqos-threads != null) ''
      coremask-hqos-threads ${coremask-hqos-threads}
    '' + optionalString (corelist-hqos-threads != null) ''
      corelist-hqos-threads ${corelist-hqos-threads}
    '' + optionalString (thread-prefix != null) ''
      thread-prefix ${thread-prefix}
    '' + optionalString (scheduler-priority != null) ''
      scheduler-priority ${toString scheduler-priority}
    '' + optionalString (extraConfig != null) ''
      ${extraConfig}
    '';
  cpuSection = ''
    cpu {
    ${cpuSectionConf}
    }
  '';
  startupConf = pkgs.writeText "startup.conf" (removeEmptyLines (''
    ${unixSection}
  '' + optionalString (dpdkSectionConf != "") ''
    ${dpdkSection}
  '' + optionalString (cpuSectionConf != "") ''
    ${cpuSection}
  '' + optionalString (cfg.extraConfig != "") ''
    ${cfg.extraConfig}
  ''));
in
{

  ###### interface

  options = {
    services.vpp = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc "Whether to run VPP.";
      };

      unix = {
        interactive = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Attach CLI to stdin/out and provide a debugging command line interface. Implies nodaemon.
          '';
        };

        nodaemon = mkOption {
          type = types.bool;
          default = true;
          description = mdDoc ''
            Do not fork / background the vpp process. Typical when invoking VPP applications from a process monitor.
          '';
        };

        log = mkOption {
          type = types.nullOr types.str;
          default = "/var/log/vpp/vpp.log";
          description = mdDoc ''
            Logs the startup configuration and all subsequent CLI commands in filename. Very useful in situations where folks don't remember or can't be bothered to include CLI commands in bug reports.
          '';
        };

        startup-config = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = mdDoc ''
            Read startup operational configuration from filename. The contents of the file will be performed as though entered at the CLI.
          '';
        };

        gid = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Sets the effective group ID to the input group ID or group name of the calling process.
          '';
        };

        full-coredump = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Ask the Linux kernel to dump all memory-mapped address regions, instead of just text+data+bss.
          '';
        };

        coredump-size = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Set the maximum size of the coredump file. The input value can be set in GB, MB, KB or bytes, or set to `unlimited`.
          '';
        };

        cli-listen = mkOption {
          type = types.nullOr types.str;
          default = "/run/vpp/cli.sock";
          description = mdDoc ''
            Bind the CLI to listen at address localhost on TCP port 5002. This will accept an ipaddress:port pair or a filesystem path; in the latter case a local Unix socket is opened instead.
          '';
        };

        cli-line-mode = mkOption {
          type = types.nullOr types.bool;
          default = false;
          description = mdDoc ''
            Disable character-by-character I/O on stdin. Useful when combined with, for example, emacs M-x gud-gdb.
          '';
        };

        cli-prompt = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Configure the CLI prompt to be string.
          '';
        };

        cli-history-limit = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = mdDoc ''
            Limit command history to <n> lines. A value of 0 disables command history. Default value: 50
          '';
        };

        cli-no-banner = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Disable the login banner on stdin and Telnet connections.
          '';
        };

        cli-no-pager = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Disable the output pager.
          '';
        };

        cli-pager-buffer-limit = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = mdDoc ''
            Limit pager buffer to <n> lines of output. A value of 0 disables the pager. Default value: 100000
          '';
        };

        runtime-dir = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Set the runtime directory, which is the default location for certain files, like socket files. Default is based on User ID used to start VPP. Typically it is `root`, which defaults to `/run/vpp/`. Otherwise, defaults to `/run/user/<uid>/vpp/`.
          '';
        };

        poll-sleep-usec = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = mdDoc ''
            Add a fixed-sleep between main loop poll. Default is 0, which is not to sleep.
          '';
        };

        pidfile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Writes the pid of the main thread in the given filename.
          '';
        };
      };

      dpdk = {
        dev = mkOption {
          type = types.nullOr (types.attrsOf (types.submodule {
            options = {
              num-rx-queues = mkOption {
                type = types.nullOr types.int;
                default = null;
                description = mdDoc ''
                  Number of RX queues to configure on the device. Default value: 1
                '';
              };

              num-tx-queues = mkOption {
                type = types.nullOr types.int;
                default = null;
                description = mdDoc ''
                  Number of TX queues to configure on the device. Default value: 1
                '';
              };

              num-rx-desc = mkOption {
                type = types.nullOr types.int;
                default = null;
                description = mdDoc ''
                  Number of RX descriptors to configure on the device. Default value: 1024
                '';
              };

              num-tx-desc = mkOption {
                type = types.nullOr types.int;
                default = null;
                description = mdDoc ''
                  Number of TX descriptors to configure on the device. Default value: 1024
                '';
              };

              vlan-strip-offload = mkOption {
                type = types.nullOr types.bool;
                default = null;
                description = mdDoc ''
                  VLAN strip offload mode for interface. VLAN stripping is off by default for all NICs except VICs, using ENIC driver, which has VLAN stripping on by default.
                '';
              };

              hqos = mkOption {
                type = types.nullOr (types.submodule {
                  options = {
                    hqos-thread = mkOption {
                      type = types.nullOr types.int;
                      default = null;
                      description = mdDoc ''
                        HQoS thread used by this interface. To setup a pool of threads that are shared by all HQoS interfaces, set via the `cpu` section using either `corelist-hqos-threads` or `coremask-hqos-threads`.
                      '';
                    };
                  };
                });
                default = null;
                description = mdDoc ''
                  Enable the Hierarchical Quaity-of-Service (HQoS) scheduler, default is disabled. This enables HQoS on specific output interface.
                '';
              };
            };
          }));
          default = null;
          description = mdDoc ''
            White-list [as in, attempt to drive] a specific PCI device. PCI-dev is a string of the form “DDDD:BB:SS.F” where:

            ```
            DDDD = Domain
            BB = Bus Number
            SS = Slot number
            F = Function
            ```

            This is the same format used in the linux sysfs tree (i.e. /sys/bus/pci/devices) for PCI device directory names.
          '';
        };

        vdev = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = mdDoc ''
            Provide a DPDK EAL command to specify bonded Ethernet interfaces, operating modes and PCI addresses of slave links. Only XOR balanced (mode 2) mode is supported.

            **Example:**

            ```
            vdev = [
              "eth_bond0,mode=2,slave=0000:0f:00.0,slave=0000:11:00.0,xmit_policy=l34"
              "eth_bond1,mode=2,slave=0000:10:00.0,slave=0000:12:00.0,xmit_policy=l34"
            ];
            ```
          '';
        };

        num-mbufs = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = mdDoc ''
            Increase number of buffers allocated. May be needed in scenarios with large number of interfaces and worker threads, or a lot of physical interfaces with multiple RSS queues. Value is per CPU socket. Default is 16384.
          '';
        };

        no-pci = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            When VPP is started, if an interface is not owned by the linux kernel (interface is administratively down), VPP will attempt to manage the interface. `no-pci` indicates that VPP should not walk the PCI table looking for interfaces.
          '';
        };

        no-hugetlb = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Don't use huge TLB pages. Potentially useful for running simulator images.
          '';
        };

        kni = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            Number of KNI interfaces. Refer to the DPDK documentation.
          '';
        };

        uio-driver = mkOption {
          type = types.nullOr (types.enum [ "uio_pci_generic" "igb_uio" "vfio-pci" "auto" ]);
          default = null;
          description = mdDoc ''
            Change UIO driver used by VPP. Default is `auto`.
          '';
        };

        socket-mem = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = mdDoc ''
            Change hugepages allocation per-socket, needed only if there is need for larger number of mbufs. Default is 64 hugepages on each detected CPU socket.
          '';
        };

        enable-tcp-udp-checksum = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Enables UDP/TCP RX checksum offload.
          '';
        };

        no-multi-seg = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Disable mutli-segment buffers, improves performance but disables Jumbo MTU support.
          '';
        };

        no-tx-checksum-offload = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Disables UDP/TCP TX checksum offload. Typically needed for use faster vector PMDs (together with no-multi-seg).
          '';
        };

        decimal-interface-names = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Format DPDK device names with decimal, as opposed to hexadecimal.
          '';
        };

        log-level = mkOption {
          type = types.nullOr (types.enum [ "emergency" "alert" "critical" "error" "warning" "notice" "info" "debug" ]);
          default = null;
          description = mdDoc ''
            Set the log level for DPDK logs. Default is `notice`.
          '';
        };
      };

      cpu = {
        workers = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = mdDoc ''
            Create <n> worker threads.

            **Example:** workers = 4;
          '';
        };

        io = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = mdDoc ''
            Create <n> I/O threads.

            **Example:** io = 2;
          '';
        };

        main-thread-io = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Handle i/o devices from thread 0, hand off traffic to worker threads. Requires “workers <n>”.
          '';
        };

        skip-cores = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = mdDoc ''
            Sets number of CPU core(s) to be skipped (1 … N-1). Skipped CPU core(s) are not used for pinning main thread and working thread(s). The main thread is automatically pinned to the first available CPU core and worker(s) are pinned to next free CPU core(s) after core assigned to main threadLeave the low nn bits of the process affinity mask clear.

            **Example:** skip-cores = 4;
          '';
        };


        main-core = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = mdDoc ''
            Assign main thread to a specific core.
          '';
        };

        coremask-workers = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Place I/O threads according to the bitmap hex-mask.

            **Example:** coremask-io = "0x0000000003000030";
          '';
        };

        corelist-workers = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Same as coremask-workers but accepts a list of cores instead of a bitmap.

            **Example:** corelist-workers = "2-3,18-19";
          '';
        };

        corelist-io = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Same as coremask-io but accepts a list of cores instead of a bitmap.

            **Example:** corelist-io = "4-5,20-21";
          '';
        };

        coremask-hqos-threads = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Place HQoS threads according to the bitmap hex-mask. A HQoS thread can run multiple HQoS objects each associated with different output interfaces.

            **Example:** coremask-hqos-threads = "0x000000000C0000C0";
          '';
        };

        corelist-hqos-threads = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Same as coremask-hqos-threads but accepts a list of cores instead of a bitmap.

            **Example:** corelist-hqos-threads = "6-7,22-23";
          '';
        };

        thread-prefix = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            Set a prefix to be prepended to each thread name. The thread name already contains an underscore. If not provided, the default is `vpp`. Currently, prefix used on threads: `vpp_main`, `vpp_stats`

            **Example:** thread-prefix = "vpp1";
          '';
        };

        scheduler-priority = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = mdDoc ''
            Set the scheduler priority. Only valid if the `scheduler-policy` is set to `fifo` or `rr`. The valid ranges for the scheduler priority depends on the `scheduler-policy` and the current kernel version running. The range is typically 1 to 99, but see the linux man pages for `sched` for more details. If this value is not set, the current linux kernel default is left in place.

            **Example:** scheduler-priority = 50;
          '';
        };

        extraConfig = mkOption {
          type = types.nullOr types.lines;
          default = null;
          description = mdDoc ''
            Extra configuration for `cpu` parameters.
          '';
        };
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = mdDoc ''
          Extra configuration for `startup.conf`.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    users.users.vpp = {
      isSystemUser = true;
      group = "vpp";
      description = "VPP daemon user";
    };

    users.groups.vpp = { };

    systemd.services.vpp = {
      description = "Vector Packet Processing Process";
      after = [ "syslog.target" "network.target" "auditd.service" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        rm -f /dev/shm/db /dev/shm/global_vm /dev/shm/vpe-api
      '';
      serviceConfig = {
        Type = "simple";
        ExecStart = "${vpp}/bin/vpp -c ${startupConf}";
        Restart = "on-failure";
        RestartSec = "5s";
        PrivateTmp = true;
        ProtectSystem = true;
      };
    };
  };
}
