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
  qemuConfigFile = pkgs.writeText "qemu.conf" ''
    ${optionalString cfg.qemuOvmf ''
      nvram = ["${pkgs.OVMF.fd}/FV/OVMF_CODE.fd:${pkgs.OVMF.fd}/FV/OVMF_VARS.fd"]
    ''}
    ${cfg.qemuVerbatimConfig}
  '';

in {

  ###### interface

  options = {

    virtualisation.libvirtd.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This option enables libvirtd, a daemon that manages
        virtual machines. Users in the "libvirtd" group can interact with
        the daemon (e.g. to start or stop VMs) using the
        <command>virsh</command> command line tool, among others.
      '';
    };

    virtualisation.libvirtd.enableKVM = mkOption {
      type = types.bool;
      default = true;
      description = ''
        This option enables support for QEMU/KVM in libvirtd.
      '';
    };

    virtualisation.libvirtd.extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra contents appended to the libvirtd configuration file,
        libvirtd.conf.
      '';
    };

    virtualisation.libvirtd.qemuVerbatimConfig = mkOption {
      type = types.lines;
      default = ''
        namespaces = []
      '';
      description = ''
        Contents written to the qemu configuration file, qemu.conf.
        Make sure to include a proper namespace configuration when
        supplying custom configuration.
      '';
    };

    virtualisation.libvirtd.qemuOvmf = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Allows libvirtd to take advantage of OVMF when creating new
        QEMU VMs with UEFI boot.
      '';
    };

    virtualisation.libvirtd.extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--verbose" ];
      description = ''
        Extra command line arguments passed to libvirtd on startup.
      '';
    };

    virtualisation.libvirtd.onShutdown = mkOption {
      type = types.enum ["shutdown" "suspend" ];
      default = "suspend";
      description = ''
        When shutting down / restarting the host what method should
        be used to gracefully halt the guests. Setting to "shutdown"
        will cause an ACPI shutdown of each guest. "suspend" will
        attempt to save the state of the guests ready to restore on boot.
      '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs;
      [ libvirt netcat-openbsd ]
       ++ optional cfg.enableKVM qemu_kvm;

    boot.kernelModules = [ "tun" ];

    users.extraGroups.libvirtd.gid = config.ids.gids.libvirtd;

    systemd.packages = [ pkgs.libvirt ];

    systemd.services.libvirtd = {
      description = "Libvirt Virtual Machine Management Daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ]
              ++ optional vswitch.enable "vswitchd.service";

      environment = {
        LIBVIRTD_ARGS = ''--config "${configFile}" ${concatStringsSep " " cfg.extraOptions}'';
      };

      path = with pkgs; [
          bridge-utils
          dmidecode
          dnsmasq
          ebtables
        ]
        ++ optional cfg.enableKVM qemu_kvm
        ++ optional vswitch.enable vswitch.package;

      preStart = ''
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

        # Copy generated qemu config to libvirt directory
        cp -f ${qemuConfigFile} /var/lib/libvirt/qemu.conf

        # libvirtd puts the full path of the emulator binary in the machine
        # config file. But this path can unfortunately be garbage collected
        # while still being used by the virtual machine. So update the
        # emulator path on each startup to something valid (re-scan $PATH).
        for file in /var/lib/libvirt/qemu/*.xml /var/lib/libvirt/lxc/*.xml; do
            test -f "$file" || continue
            # get (old) emulator path from config file
            emulator=$("${pkgs.xmlstarlet}/bin/xmlstarlet" select --template --value-of "/domain/devices/emulator" "$file")
            # get a (definitely) working emulator path by re-scanning $PATH
            new_emulator=$(PATH=${pkgs.libvirt}/libexec:$PATH command -v $(basename "$emulator"))
            # write back
            "${pkgs.xmlstarlet}/bin/xmlstarlet" edit --inplace --update "/domain/devices/emulator" -v "$new_emulator" "$file"
        done
      ''; # */

      serviceConfig = {
        Type = "notify";
        KillMode = "process"; # when stopping, leave the VMs alone
        Restart = "on-failure";
      };
    };

    systemd.services.libvirt-guests = {
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ coreutils libvirt gawk ];
    };

    systemd.sockets.virtlogd = {
      description = "Virtual machine log manager socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "/run/libvirt/virtlogd-sock" ];
    };

    systemd.services.virtlogd = {
      description = "Virtual machine log manager";
      serviceConfig.ExecStart = "@${pkgs.libvirt}/sbin/virtlogd virtlogd";
    };

    systemd.sockets.virtlockd = {
      description = "Virtual machine lock manager socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "/run/libvirt/virtlockd-sock" ];
    };

    systemd.services.virtlockd = {
      description = "Virtual machine lock manager";
      serviceConfig.ExecStart = "@${pkgs.libvirt}/sbin/virtlockd virtlockd";
    };
  };
}
