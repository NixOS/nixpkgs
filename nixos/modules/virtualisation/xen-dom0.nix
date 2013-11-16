# Xen hypervisor (Dom0) support.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.virtualisation.xen;

  xen = pkgs.xen;

  xendConfig = pkgs.writeText "xend-config.sxp"
    ''
      (loglevel DEBUG)
      (network-script network-bridge)
      (vif-script vif-bridge)
    '';

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

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ xen ];

    # Domain 0 requires a pvops-enabled kernel.
    boot.kernelPackages = pkgs.linuxPackages_3_2_xen;

    boot.kernelModules =
      [ "xen_evtchn" "xen_gntdev" "xen_blkback" "xen_netback" "xen_pciback"
        "blktap" "tun"
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
                ${pkgs.utillinux}/bin/mount -t xenfs none /proc/xen
        fi
      '';

    jobs.xend =
      { description = "Xen Control Daemon";

        startOn = "stopped udevtrigger";

        path =
          [ pkgs.bridge_utils pkgs.gawk pkgs.iproute pkgs.nettools
            pkgs.utillinux pkgs.bash xen pkgs.pciutils pkgs.procps
          ];

        environment.XENCONSOLED_TRACE = "hv";

        preStart =
          ''
            mkdir -p /var/log/xen/console -m 0700

            ${xen}/sbin/xend start

            # Wait until Xend is running.
            for ((i = 0; i < 60; i++)); do echo "waiting for xend..."; ${xen}/sbin/xend status && break; done

            ${xen}/sbin/xend status || exit 1
          '';

        postStop = "${xen}/sbin/xend stop";
      };

    jobs.xendomains =
      { description = "Automatically starts, saves and restores Xen domains on startup/shutdown";

        startOn = "started xend";

        stopOn = "starting shutdown and stopping xend";

        restartIfChanged = false;
        
        path = [ pkgs.xen ];

        environment.XENDOM_CONFIG = "${xen}/etc/sysconfig/xendomains";

        preStart =
          ''
            mkdir -p /var/lock/subsys -m 755
            ${xen}/etc/init.d/xendomains start
          '';

        postStop = "${xen}/etc/init.d/xendomains stop";
      };

    # To prevent a race between dhcpcd and xend's bridge setup script
    # (which renames eth* to peth* and recreates eth* as a virtual
    # device), start dhcpcd after xend.
    jobs.dhcpcd.startOn = mkOverride 50 "started xend";

    environment.etc =
      [ { source = xendConfig;
          target = "xen/xend-config.sxp";
        }
        { source = "${xen}/etc/xen/scripts";
          target = "xen/scripts";
        }
      ];

    # Xen provides udev rules.
    services.udev.packages = [ xen ];

    services.udev.path = [ pkgs.bridge_utils pkgs.iproute ];

  };

}
