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

  };

}
