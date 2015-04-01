# Xen hypervisor (Dom0) support.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.xen;
  xen = pkgs.xen;
in

{
  ###### interface

  options = {

    virtualisation.xen.enable =
      mkOption {
        default = false;
        description =
          ''
            Setting this option enables the Xen hypervisor, a
            virtualisation technology that allows multiple virtual
            machines, known as <emphasis>domains</emphasis>, to run
            concurrently on the physical machine.  NixOS runs as the
            privileged <emphasis>Domain 0</emphasis>.  This option
            requires a reboot to take effect.
          '';
      };

    virtualisation.xen.bootParams =
      mkOption {
        default = "";
        description =
          ''
            Parameters passed to the Xen hypervisor at boot time.
          '';
      };

    virtualisation.xen.domain0MemorySize =
      mkOption {
        default = 0;
        example = 512;
        description =
          ''
            Amount of memory (in MiB) allocated to Domain 0 on boot.
            If set to 0, all memory is assigned to Domain 0.
          '';
      };

    virtualisation.xen.bridge =
      mkOption {
        default = "xenbr0";
        description =
          ''
            Create a bridge for the Xen domUs to connect to.
          '';
      };

    virtualisation.xen.stored =
      mkOption {
        type = types.path;
        description =
          ''
            Xen Store daemon to use. Defaults to oxenstored of the xen package.
          '';
      };

    virtualisation.xen.trace =
      mkOption {
        default = false;
        description =
          ''
            Enable Xen tracing.
          '';
      };
  };


  ###### implementation

  config = mkIf cfg.enable {
    assertions = [ {
      assertion = pkgs.stdenv.isx86_64;
      message = "Xen currently not supported on ${pkgs.stdenv.system}";
    } {
      assertion = config.boot.loader.grub.enable && (config.boot.loader.grub.efiSupport == false);
      message = "Xen currently does not support EFI boot";
    } ];

    virtualisation.xen.stored = mkDefault "${xen}/bin/oxenstored";

    environment.systemPackages = [ xen ];

    # Make sure Domain 0 gets the required configuration
    #boot.kernelPackages = pkgs.boot.kernelPackages.override { features={xen_dom0=true;}; };

    boot.kernelModules =
      [ "xen-evtchn" "xen-gntdev" "xen-gntalloc" "xen-blkback" "xen-netback"
        "xen-pciback" "evtchn" "gntdev" "netbk" "blkbk" "xen-scsibk"
        "usbbk" "pciback" "xen-acpi-processor" "blktap2" "tun" "netxen_nic"
        "xen_wdt" "xen-acpi-processor" "xen-privcmd" "xen-scsiback"
        "xenfs"
      ];


    # The radeonfb kernel module causes the screen to go black as soon
    # as it's loaded, so don't load it.
    boot.blacklistedKernelModules = [ "radeonfb" ];

    # Increase the number of loopback devices from the default (8),
    # which is way too small because every VM virtual disk requires a
    # loopback device.
    boot.extraModprobeConfig =
      ''
        options loop max_loop=64
      '';

    virtualisation.xen.bootParams = [] ++
      optionals cfg.trace [ "loglvl=all" "guest_loglvl=all" ] ++
      optional (cfg.domain0MemorySize != 0) "dom0_mem=${toString cfg.domain0MemorySize}M";

    system.extraSystemBuilderCmds =
      ''
        ln -s ${xen}/boot/xen.gz $out/xen.gz
        echo "${toString cfg.bootParams}" > $out/xen-params
      '';

    # Mount the /proc/xen pseudo-filesystem.
    system.activationScripts.xen =
      ''
        if [ -d /proc/xen ]; then
            ${pkgs.kmod}/bin/modprobe xenfs 2> /dev/null
            ${pkgs.utillinux}/bin/mountpoint -q /proc/xen || \
                ${pkgs.utillinux}/bin/mount -t xenfs none /proc/xen
        fi
      '';

    # Domain 0 requires a pvops-enabled kernel.
    system.requiredKernelConfig = with config.lib.kernelConfig;
      [ (isYes "XEN")
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


    environment.etc =
      [ { source = "${xen}/etc/xen/xl.conf";
          target = "xen/xl.conf";
        }
      ];

    # Xen provides udev rules.
    services.udev.packages = [ xen ];

    services.udev.path = [ pkgs.bridge-utils pkgs.iproute ];

    systemd.services.xen-store = {
      description = "Xen Store Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "xen-store.socket" ];
      requires = [ "xen-store.socket" ];
      preStart = ''
        export XENSTORED_ROOTDIR="/var/lib/xenstored"
        rm -f "$XENSTORED_ROOTDIR"/tdb* &>/dev/null

        mkdir -p /var/run
        ${optionalString cfg.trace "mkdir -p /var/log/xen"}
        grep -q control_d /proc/xen/capabilities
        '';
      serviceConfig.ExecStart = ''
        ${cfg.stored}${optionalString cfg.trace " -T /var/log/xen/xenstored-trace.log"} --no-fork
        '';
      postStart = ''
        time=0
        timeout=30
        # Wait for xenstored to actually come up, timing out after 30 seconds
        while [ $time -lt $timeout ] && ! `${pkgs.xen}/bin/xenstore-read -s / >/dev/null 2>&1` ; do
            time=$(($time+1))
            sleep 1
        done

        # Exit if we timed out
        if ! [ $time -lt $timeout ] ; then
            echo "Could not start Xenstore Daemon"
            exit 1
        fi

        ${pkgs.xen}/bin/xenstore-write "/local/domain/0/name" "Domain-0"
        ${pkgs.xen}/bin/xenstore-write "/local/domain/0/domid" 0
        '';
    };

    systemd.sockets.xen-store = {
      description = "XenStore Socket for userspace API";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = [ "/var/run/xenstored/socket" "/var/run/xenstored/socket_ro" ];
        SocketMode = "0660";
        SocketUser = "root";
        SocketGroup = "root";
      };
    };


    systemd.services.xen-console = {
      description = "Xen Console Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "xen-store.service" ];
      preStart = ''
        mkdir -p /var/run/xen
        ${optionalString cfg.trace "mkdir -p /var/log/xen"}
        grep -q control_d /proc/xen/capabilities
        '';
      serviceConfig = {
        ExecStart = ''
          ${pkgs.xen}/bin/xenconsoled${optionalString cfg.trace " --log=all --log-dir=/var/log/xen"}
          '';
      };
    };


    systemd.services.xen-qemu = {
      description = "Xen Qemu Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "xen-console.service" ];
      serviceConfig.ExecStart = ''
        ${pkgs.xen}/lib/xen/bin/qemu-system-i386 -xen-domid 0 -xen-attach -name dom0 -nographic -M xenpv \
           -monitor /dev/null -serial /dev/null -parallel /dev/null
        '';
    };


    systemd.services.xen-watchdog = {
      description = "Xen Watchdog Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "xen-qemu.service" ];
      serviceConfig.ExecStart = "${pkgs.xen}/bin/xenwatchdogd 30 15";
      serviceConfig.Type = "forking";
      serviceConfig.RestartSec = "1";
      serviceConfig.Restart = "on-failure";
    };


    systemd.services.xen-bridge = {
      description = "Xen bridge";
      wantedBy = [ "multi-user.target" ];
      before = [ "xen-domains.service" ];
      serviceConfig.RemainAfterExit = "yes";
      serviceConfig.ExecStart = ''
        ${pkgs.bridge-utils}/bin/brctl addbr ${cfg.bridge}
        ${pkgs.inetutils}/bin/ifconfig ${cfg.bridge} up
        '';
      serviceConfig.ExecStop = ''
        ${pkgs.inetutils}/bin/ifconfig ${cfg.bridge} down
        ${pkgs.bridge-utils}/bin/brctl delbr ${cfg.bridge}
        '';
    };

    systemd.services.xen-domains = {
      description = "Xen domains - automatically starts, saves and restores Xen domains";
      wantedBy = [ "multi-user.target" ];
      after = [ "xen-bridge.service" "xen-qemu.service" ];
      ## To prevent a race between dhcpcd and xend's bridge setup script
      ## (which renames eth* to peth* and recreates eth* as a virtual
      ## device), start dhcpcd after xend.
      before = [ "dhcpd.service" ];
      restartIfChanged = false;
      serviceConfig.RemainAfterExit = "yes";
      path = [ pkgs.xen ];
      environment.XENDOM_CONFIG = "${pkgs.xen}/etc/sysconfig/xendomains";
      preStart = "mkdir -p /var/lock/subsys -m 755";
      serviceConfig.ExecStart = "${pkgs.xen}/etc/init.d/xendomains start";
      serviceConfig.ExecStop = "${pkgs.xen}/etc/init.d/xendomains stop";
    };

  };

}
