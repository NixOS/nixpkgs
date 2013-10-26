# Upstart jobs for libvirtd.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.virtualisation.libvirtd;
  configFile = pkgs.writeText "libvirtd.conf" ''
    unix_sock_group = "libvirtd"
    unix_sock_rw_perms = "0770"
    auth_unix_ro = "none"
    auth_unix_rw = "none"
    ${cfg.extraConfig}
  '';

in

{
  ###### interface

  options = {

    virtualisation.libvirtd.enable =
      mkOption {
        default = false;
        description =
          ''
            This option enables libvirtd, a daemon that manages
            virtual machines. Users in the "libvirtd" group can interact with
            the daemon (e.g. to start or stop VMs) using the
            <command>virsh</command> command line tool, among others.
          '';
      };

    virtualisation.libvirtd.enableKVM =
      mkOption {
        default = true;
        description =
          ''
            This option enables support for QEMU/KVM in libvirtd.
          '';
      };

    virtualisation.libvirtd.extraConfig =
      mkOption {
        default = "";
        description =
          ''
            Extra contents appended to the libvirtd configuration file,
            libvirtd.conf.
          '';
      };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages =
      [ pkgs.libvirt pkgs.netcat-openbsd ]
       ++ optional cfg.enableKVM pkgs.qemu_kvm;

    boot.kernelModules = [ "tun" ];

    systemd.services.libvirtd =
      { description = "Libvirt Virtual Machine Management Daemon";

        wantedBy = [ "multi-user.target" ];
        after = [ "systemd-udev-settle.service" ];

        path =
          [ pkgs.bridge_utils pkgs.dmidecode pkgs.dnsmasq
            pkgs.ebtables
          ] ++ optional cfg.enableKVM pkgs.qemu_kvm;

        preStart =
          ''
            mkdir -p /var/log/libvirt/qemu -m 755
            rm -f /var/run/libvirtd.pid

            mkdir -p /var/lib/libvirt -m 700
            mkdir -p /var/lib/libvirt/dnsmasq -m 700

            # Libvirt unfortunately writes mutable state (such as
            # runtime changes to VM, network or filter configurations)
            # to /etc.  So we can't use environment.etc to make the
            # default network and filter definitions available, since
            # libvirt will then modify the originals in the Nix store.
            # So here we copy them instead.  Ugly.
            for i in $(cd ${pkgs.libvirt}/etc && echo \
                libvirt/qemu/networks/*.xml libvirt/qemu/networks/autostart/*.xml \
                libvirt/nwfilter/*.xml );
            do
                mkdir -p /etc/$(dirname $i) -m 755
                cp -fpd ${pkgs.libvirt}/etc/$i /etc/$i
            done
          ''; # */

        serviceConfig.ExecStart = ''@${pkgs.libvirt}/sbin/libvirtd libvirtd --config "${configFile}" --daemon --verbose'';
        serviceConfig.Type = "forking";
        serviceConfig.KillMode = "process"; # when stopping, leave the VMs alone

        # Wait until libvirtd is ready to accept requests.
        postStart =
          ''
            for ((i = 0; i < 60; i++)); do
                if ${pkgs.libvirt}/bin/virsh list > /dev/null; then exit 0; fi
                sleep 1
            done
            exit 1 # !!! seems to be ignored
          '';
      };

    jobs."libvirt-guests" =
      { description = "Libvirt Virtual Machines";

        wantedBy = [ "multi-user.target" ];
        wants = [ "libvirtd.service" ];
        after = [ "libvirtd.service" ];

        # We want to suspend VMs only on shutdown, but Upstart is broken.
        #stopOn = "";

        restartIfChanged = false;

        path = [ pkgs.gettext pkgs.libvirt pkgs.gawk ];

        preStart =
          ''
            mkdir -p /var/lock/subsys -m 755
            ${pkgs.libvirt}/etc/rc.d/init.d/libvirt-guests start || true
          '';

        postStop = "${pkgs.libvirt}/etc/rc.d/init.d/libvirt-guests stop";

        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
      };

    users.extraGroups.libvirtd.gid = config.ids.gids.libvirtd;

  };

}
