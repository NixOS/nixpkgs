# Xen hypervisor (Dom0) support.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.xen;

  xen = pkgs.xen;

 #xendConfig = pkgs.writeText "xend-config.sxp"
 #  ''
 #    (loglevel DEBUG)
 #    (network-script network-bridge)
 #    (vif-script vif-bridge)
 #  '';

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

    virtualisation.xen.storaged =
      mkOption {
        default = "${pkgs.xen}/bin/oxenstored";
        description =
          ''
            Xen storage daemon to use.
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

    environment.systemPackages = [ xen ];

    # Make sure Domain 0 gets the required configuration
    #boot.kernelPackages = pkgs.boot.kernelPackages.override { features={xen_dom0=true;}; };

    boot.kernelModules =
      [ "xen-evtchn" "xen-gntdev" "xen-gntalloc" "xen-blkback" "xen-netback"
        "xen-pciback" "evtchn" "gntdev" "netbk" "blkbk" "xen-scsibk"
        "usbbk" "pciback" "xen-acpi-processor" "blktap2" "tun"
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

    virtualisation.xen.bootParams =
      [ "loglvl=all" "guest_loglvl=all" ] ++
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
            ${pkgs.sysvtools}/bin/mountpoint -q /proc/xen || \
                ${pkgs.utillinux}/bin/mount -t xenfs xenfs /proc/xen
        fi
      '';

    # Domain 0 requires a pvops-enabled kernel.
    system.requiredKernelConfig = with config.lib.kernelConfig;
      [ (isYes "XEN")
        (isYes "X86_IO_APIC")
        (isYes "ACPI")
        (isYes "ACPI_PROCFS")
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
        (isYes "XEN_PRIVILEGED_GUEST")
        (isYes "XEN_BALLOON")
        (isYes "XEN_SCRUB_PAGES")
      ];


    environment.etc =
      [ #{ source = xendConfig;
        #  target = "xen/xend-config.sxp";
        #}
        { source = "${xen}/etc/xen/scripts";
          target = "xen/scripts";
        }
      ];

    # Xen provides udev rules.
    services.udev.packages = [ xen ];

    services.udev.path = [ pkgs.bridge_utils pkgs.iproute ];


    systemd.services.xen-storage = {
      description = "Xen Storage Daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        export XENSTORED_ROOTDIR="/var/lib/xenstored"
        rm -f "$XENSTORED_ROOTDIR"/tdb* &>/dev/null

        mkdir -p /var/run/xen
        '';
      serviceConfig.ExecStart = ''
        ${cfg.storaged}${optionalString cfg.trace " -T /var/log/xen/xenstored-trace.log"} --no-fork --pid-file /var/run/xen/xenstored.pid
        '';
      postStart = ''
        local time=0
        local timeout=30
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
      postStop = ''
          rm -f /var/run/xen/xenstored.pid
        '';
    };


    systemd.services.xen-console = {
      description = "Xen Console Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "xen-storage.service" ];
      preStart = ''
          mkdir -p /var/run/xen
        '';
      serviceConfig.ExecStart = ''
        ${cfg.storaged}${optionalString cfg.trace " --log=all"} --pid-file /var/run/xen/xenconsoled.pid
        '';
      serviceConfig.Type = "forking";
      serviceConfig.PIDFile = "/var/run/xen/xenconsoled.pid";
      postStop = ''
          rm -f /var/run/xen/xenconsoled.pid
        '';
    };


    systemd.services.xen-qemu = {
      description = "Xen Qemu Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "xen-console.service" ];
      preStart = ''
          mkdir -p /var/run/xen
        '';
      serviceConfig.ExecStart = ''
        ${pkgs.xen}/lib/xen/bin/qemu-system-i386 -xen-domid 0 -xen-attach -name dom0 -nographic -M xenpv \
           -monitor /dev/null -serial /dev/null -parallel /dev/null \
           -pidfile /var/run/xen/qemu-dom0.pid
        '';
      postStop = ''
          rm -f /var/run/xen/qemu-dom0.pid
        '';
    };


    systemd.services.xen-watchdog = {
      description = "Xen Watchdog Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "xen-qemu.service" ];
      preStart = ''
          mkdir -p /var/run/xen
        '';
      serviceConfig.ExecStart = ''
        ${pkgs.xen}/bin/xenwatchdogd 30 15
        echo $! > /var/run/xen/xenwatchdogd.pid
      '';
      serviceConfig.Type = "forking";
      serviceConfig.PIDFile = "rm -f /var/run/xen/xenwatchdogd.pid";
      serviceConfig.Restart = "always";
      postStop = ''
          rm -f /var/run/xen/xenwatchdogd.pid
        '';
    };


    systemd.services.xen-domains = {
      description = "Automatically starts, saves and restores Xen domains on startup/shutdown";
      wantedBy = [ "multi-user.target" ];
      after = [ "xen-qemu.service" ];
      ## To prevent a race between dhcpcd and xend's bridge setup script
      ## (which renames eth* to peth* and recreates eth* as a virtual
      ## device), start dhcpcd after xend.
      #before = [ "dhcpd.service" ];
      restartIfChanged = false;
      serviceConfig.RemainAfterExit = "yes";
      path = [ pkgs.xen ];
      environment.XENDOM_CONFIG = "${pkgs.xen}/etc/sysconfig/xendomains";
      preStart = ''
          mkdir -p /var/lock/subsys -m 755
          ${pkgs.xen}/etc/init.d/xendomains start
        '';
      postStop = "${pkgs.xen}/etc/init.d/xendomains stop";
    };

  };

}
