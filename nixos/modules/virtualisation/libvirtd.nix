# Systemd services for libvirtd.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.libvirtd;
  vswitch = config.virtualisation.vswitch;
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
        type = types.bool;
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
        type = types.bool;
        default = true;
        description =
          ''
            This option enables support for QEMU/KVM in libvirtd.
          '';
      };

    virtualisation.libvirtd.extraConfig =
      mkOption {
        type = types.lines;
        default = "";
        description =
          ''
            Extra contents appended to the libvirtd configuration file,
            libvirtd.conf.
          '';
      };

    virtualisation.libvirtd.extraOptions =
      mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "--verbose" ];
        description =
          ''
            Extra command line arguments passed to libvirtd on startup.
          '';
      };

    virtualisation.libvirtd.onShutdown =
      mkOption {
        type = types.enum ["shutdown" "suspend" ];
        default = "suspend";
        description =
          ''
            When shutting down / restarting the host what method should
            be used to gracefully halt the guests. Setting to "shutdown"
            will cause an ACPI shutdown of each guest. "suspend" will
            attempt to save the state of the guests ready to restore on boot.
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
        after = [ "systemd-udev-settle.service" ]
                ++ optional vswitch.enable "vswitchd.service";

        path = [ 
            pkgs.bridge-utils 
            pkgs.dmidecode 
            pkgs.dnsmasq
            pkgs.ebtables
          ] 
          ++ optional cfg.enableKVM pkgs.qemu_kvm
          ++ optional vswitch.enable vswitch.package;

        preStart =
          ''
            mkdir -p /var/log/libvirt/qemu -m 755
            rm -f /var/run/libvirtd.pid

            mkdir -p /var/lib/libvirt
            mkdir -p /var/lib/libvirt/dnsmasq

            chmod 755 /var/lib/libvirt
            chmod 755 /var/lib/libvirt/dnsmasq

            # Copy default libvirt network config .xml files to /var/lib
            # Files modified by the user will not be overwritten
            for i in $(cd ${pkgs.libvirt}/var/lib && echo \
                libvirt/qemu/networks/*.xml libvirt/qemu/networks/autostart/*.xml \
                libvirt/nwfilter/*.xml );
            do
                mkdir -p /var/lib/$(dirname $i) -m 755
                cp -npd ${pkgs.libvirt}/var/lib/$i /var/lib/$i
            done

            # libvirtd puts the full path of the emulator binary in the machine
            # config file. But this path can unfortunately be garbage collected
            # while still being used by the virtual machine. So update the
            # emulator path on each startup to something valid (re-scan $PATH).
            for file in /etc/libvirt/qemu/*.xml /etc/libvirt/lxc/*.xml; do
                test -f "$file" || continue
                # get (old) emulator path from config file
                emulator=$(grep "^[[:space:]]*<emulator>" "$file" | sed 's,^[[:space:]]*<emulator>\(.*\)</emulator>.*,\1,')
                # get a (definitely) working emulator path by re-scanning $PATH
                new_emulator=$(PATH=${pkgs.libvirt}/libexec:$PATH command -v $(basename "$emulator"))
                # write back
                sed -i "s,^[[:space:]]*<emulator>.*,    <emulator>$new_emulator</emulator> <!-- WARNING: emulator dirname is auto-updated by the nixos libvirtd module -->," "$file"
            done
          ''; # */

        serviceConfig.ExecStart = ''@${pkgs.libvirt}/sbin/libvirtd libvirtd --config "${configFile}" --daemon ${concatStringsSep " " cfg.extraOptions}'';
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

    systemd.services."libvirt-guests" = {
      description = "Libvirt Virtual Machines";

      wantedBy = [ "multi-user.target" ];
      wants = [ "libvirtd.service" ];
      after = [ "libvirtd.service" ];

      restartIfChanged = false;

      path = with pkgs; [ gettext libvirt gawk ];

      preStart = ''
        mkdir -p /var/lock/subsys -m 755
        ${pkgs.libvirt}/etc/rc.d/init.d/libvirt-guests start || true
      '';

      postStop = ''
        export PATH=${pkgs.gettext}/bin:$PATH
        export ON_SHUTDOWN=${cfg.onShutdown}
        ${pkgs.libvirt}/etc/rc.d/init.d/libvirt-guests stop
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    users.extraGroups.libvirtd.gid = config.ids.gids.libvirtd;

  };

}
