# Xen hypervisor (Dom0) support.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.xen;
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

    virtualisation.xen.package = mkOption {
      type = types.package;
      default = pkgs.xen;
      defaultText = "pkgs.xen";
      example = literalExample "pkgs.xen-light";
      description = ''
        The package used for Xen binary.
      '';
    };

    virtualisation.xen.qemu = mkOption {
      type = types.path;
      default = "${pkgs.xen}/lib/xen/bin/qemu-system-i386";
      defaultText = "''${pkgs.xen}/lib/xen/bin/qemu-system-i386";
      example = literalExample "''${pkgs.qemu_xen-light}/bin/qemu-system-i386";
      description = ''
        The qemu binary to use for Dom-0 backend.
      '';
    };

    virtualisation.xen.qemu-package = mkOption {
      type = types.package;
      default = pkgs.xen;
      defaultText = "pkgs.xen";
      example = literalExample "pkgs.qemu_xen-light";
      description = ''
        The package with qemu binaries for xendomains.
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

    virtualisation.xen.bridge = {
        name = mkOption {
          default = "xenbr0";
          description = ''
              Name of bridge the Xen domUs connect to.
            '';
        };

        address = mkOption {
          type = types.str;
          default = "172.16.0.1";
          description = ''
            IPv4 address of the bridge.
          '';
        };

        prefixLength = mkOption {
          type = types.addCheck types.int (n: n >= 0 && n <= 32);
          default = 16;
          description = ''
            Subnet mask of the bridge interface, specified as the number of
            bits in the prefix (<literal>24</literal>).
            A DHCP server will provide IP addresses for the whole, remaining
            subnet.
          '';
        };
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

    virtualisation.xen.stored = mkDefault "${cfg.package}/bin/oxenstored";

    environment.systemPackages = [ cfg.package ];

    # Make sure Domain 0 gets the required configuration
    #boot.kernelPackages = pkgs.boot.kernelPackages.override { features={xen_dom0=true;}; };

    boot.kernelModules =
      [ "xen-evtchn" "xen-gntdev" "xen-gntalloc" "xen-blkback" "xen-netback"
        "xen-pciback" "evtchn" "gntdev" "netbk" "blkbk" "xen-scsibk"
        "usbbk" "pciback" "xen-acpi-processor" "blktap2" "tun" "netxen_nic"
        "xen_wdt" "xen-acpi-processor" "xen-privcmd" "xen-scsiback"
        "xenfs"
      ];

    # The xenfs module is needed in system.activationScripts.xen, but
    # the modprobe command there fails silently. Include xenfs in the
    # initrd as a work around.
    boot.initrd.kernelModules = [ "xenfs" ];

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
        ln -s ${cfg.package}/boot/xen.gz $out/xen.gz
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
      [ { source = "${cfg.package}/etc/xen/xl.conf";
          target = "xen/xl.conf";
        }
        { source = "${cfg.package}/etc/xen/scripts";
          target = "xen/scripts";
        }
        { source = "${cfg.package}/etc/default/xendomains";
          target = "default/xendomains";
        }
      ];

    # Xen provides udev rules.
    services.udev.packages = [ cfg.package ];

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
        mkdir -p /var/log/xen # Running xl requires /var/log/xen and /var/lib/xen,
        mkdir -p /var/lib/xen # so we create them here unconditionally.
        grep -q control_d /proc/xen/capabilities
        '';
      serviceConfig.ExecStart = ''
        ${cfg.stored}${optionalString cfg.trace " -T /var/log/xen/xenstored-trace.log"} --no-fork
        '';
      postStart = ''
        time=0
        timeout=30
        # Wait for xenstored to actually come up, timing out after 30 seconds
        while [ $time -lt $timeout ] && ! `${cfg.package}/bin/xenstore-read -s / >/dev/null 2>&1` ; do
            time=$(($time+1))
            sleep 1
        done

        # Exit if we timed out
        if ! [ $time -lt $timeout ] ; then
            echo "Could not start Xenstore Daemon"
            exit 1
        fi

        ${cfg.package}/bin/xenstore-write "/local/domain/0/name" "Domain-0"
        ${cfg.package}/bin/xenstore-write "/local/domain/0/domid" 0
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
          ${cfg.package}/bin/xenconsoled${optionalString cfg.trace " --log=all --log-dir=/var/log/xen"}
          '';
      };
    };


    systemd.services.xen-qemu = {
      description = "Xen Qemu Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "xen-console.service" ];
      serviceConfig.ExecStart = ''
        ${cfg.qemu} -xen-attach -xen-domid 0 -name dom0 -M xenpv \
           -nographic -monitor /dev/null -serial /dev/null -parallel /dev/null
        '';
    };


    systemd.services.xen-watchdog = {
      description = "Xen Watchdog Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "xen-qemu.service" ];
      serviceConfig.ExecStart = "${cfg.package}/bin/xenwatchdogd 30 15";
      serviceConfig.Type = "forking";
      serviceConfig.RestartSec = "1";
      serviceConfig.Restart = "on-failure";
    };


    systemd.services.xen-bridge = {
      description = "Xen bridge";
      wantedBy = [ "multi-user.target" ];
      before = [ "xen-domains.service" ];
      preStart = ''
        mkdir -p /var/run/xen
        touch /var/run/xen/dnsmasq.pid
        touch /var/run/xen/dnsmasq.etherfile
        touch /var/run/xen/dnsmasq.leasefile

        IFS='-' read -a data <<< `${pkgs.sipcalc}/bin/sipcalc ${cfg.bridge.address}/${toString cfg.bridge.prefixLength} | grep Usable\ range`
        export XEN_BRIDGE_IP_RANGE_START="${"\${data[1]//[[:blank:]]/}"}"
        export XEN_BRIDGE_IP_RANGE_END="${"\${data[2]//[[:blank:]]/}"}"

        IFS='-' read -a data <<< `${pkgs.sipcalc}/bin/sipcalc ${cfg.bridge.address}/${toString cfg.bridge.prefixLength} | grep Network\ address`
        export XEN_BRIDGE_NETWORK_ADDRESS="${"\${data[1]//[[:blank:]]/}"}"

        echo "${cfg.bridge.address} host gw dns" > /var/run/xen/dnsmasq.hostsfile

        cat <<EOF > /var/run/xen/dnsmasq.conf
        no-daemon
        pid-file=/var/run/xen/dnsmasq.pid
        interface=${cfg.bridge.name}
        except-interface=lo
        bind-interfaces
        auth-server=dns.xen.local,${cfg.bridge.name}
        auth-zone=xen.local,$XEN_BRIDGE_NETWORK_ADDRESS/${toString cfg.bridge.prefixLength}
        domain=xen.local
        addn-hosts=/var/run/xen/dnsmasq.hostsfile
        expand-hosts
        strict-order
        no-hosts
        bogus-priv
        no-resolv
        no-poll
        filterwin2k
        clear-on-reload
        domain-needed
        dhcp-hostsfile=/var/run/xen/dnsmasq.etherfile
        dhcp-authoritative
        dhcp-range=$XEN_BRIDGE_IP_RANGE_START,$XEN_BRIDGE_IP_RANGE_END
        dhcp-no-override
        no-ping
        dhcp-leasefile=/var/run/xen/dnsmasq.leasefile
        EOF

        # DHCP
        ${pkgs.iptables}/bin/iptables -w -I INPUT  -i ${cfg.bridge.name} -p tcp -s $XEN_BRIDGE_NETWORK_ADDRESS/${toString cfg.bridge.prefixLength} --sport 68 --dport 67 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -w -I INPUT  -i ${cfg.bridge.name} -p udp -s $XEN_BRIDGE_NETWORK_ADDRESS/${toString cfg.bridge.prefixLength} --sport 68 --dport 67 -j ACCEPT
        # DNS
        ${pkgs.iptables}/bin/iptables -w -I INPUT  -i ${cfg.bridge.name} -p tcp -d ${cfg.bridge.address} --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
        ${pkgs.iptables}/bin/iptables -w -I INPUT  -i ${cfg.bridge.name} -p udp -d ${cfg.bridge.address} --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT

        ${pkgs.bridge-utils}/bin/brctl addbr ${cfg.bridge.name}
        ${pkgs.inetutils}/bin/ifconfig ${cfg.bridge.name} ${cfg.bridge.address}
        ${pkgs.inetutils}/bin/ifconfig ${cfg.bridge.name} up
      '';
      serviceConfig.ExecStart = "${pkgs.dnsmasq}/bin/dnsmasq --conf-file=/var/run/xen/dnsmasq.conf";
      postStop = ''
        ${pkgs.inetutils}/bin/ifconfig ${cfg.bridge.name} down
        ${pkgs.bridge-utils}/bin/brctl delbr ${cfg.bridge.name}

        # DNS
        ${pkgs.iptables}/bin/iptables -w -D INPUT  -i ${cfg.bridge.name} -p udp -d ${cfg.bridge.address} --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
        ${pkgs.iptables}/bin/iptables -w -D INPUT  -i ${cfg.bridge.name} -p tcp -d ${cfg.bridge.address} --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
        # DHCP
        ${pkgs.iptables}/bin/iptables -w -D INPUT  -i ${cfg.bridge.name} -p udp --sport 68 --dport 67 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -w -D INPUT  -i ${cfg.bridge.name} -p tcp --sport 68 --dport 67 -j ACCEPT
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
      path = [ cfg.package cfg.qemu-package ];
      environment.XENDOM_CONFIG = "${cfg.package}/etc/sysconfig/xendomains";
      preStart = "mkdir -p /var/lock/subsys -m 755";
      serviceConfig.ExecStart = "${cfg.package}/etc/init.d/xendomains start";
      serviceConfig.ExecStop = "${cfg.package}/etc/init.d/xendomains stop";
    };

  };

}
