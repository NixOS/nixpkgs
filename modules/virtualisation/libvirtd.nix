# Upstart jobs for libvirtd.

{ config, pkgs, ... }:

with pkgs.lib;

let 

  cfg = config.virtualisation.libvirtd; 

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
            virtual machines.  You can interact with the daemon
            (e.g. to start or stop VMs) using the
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

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.libvirt ];

    jobs.libvirtd =
      { description = "Libvirtd virtual machine management daemon";

        startOn = "stopped udevtrigger";

        path =
          [ pkgs.bridge_utils pkgs.dmidecode
          ] ++ optional cfg.enableKVM pkgs.qemu_kvm;

        exec = "${pkgs.libvirt}/sbin/libvirtd --daemon --verbose";

        daemonType = "daemon";
      };

    jobs.libvirt_guests =
      { name = "libvirt-guests";
      
        description = "Job to save/restore libvirtd VMs";

        startOn = "started libvirtd";

        # We want to suspend VMs only on shutdown, but Upstart is broken.
        #stopOn = "starting shutdown and stopping libvirtd";
        stopOn = "stopping libvirtd";

        path = [ pkgs.gettext pkgs.libvirt pkgs.gawk ];

        preStart = 
          ''
            mkdir -p /var/lock/subsys -m 755
            ${pkgs.libvirt}/etc/rc.d/init.d/libvirt-guests start
          '';

        postStop = "${pkgs.libvirt}/etc/rc.d/init.d/libvirt-guests stop";
      };

  };

}
