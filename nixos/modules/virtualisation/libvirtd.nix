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
      nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
    ''}
    ${optionalString (!cfg.qemuRunAsRoot) ''
      user = "qemu-libvirtd"
      group = "qemu-libvirtd"
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

    virtualisation.libvirtd.qemuPackage = mkOption {
      type = types.package;
      default = pkgs.qemu;
      description = ''
        Qemu package to use with libvirt.
        `pkgs.qemu` can emulate alien architectures (e.g. aarch64 on x86)
        `pkgs.qemu_kvm` saves disk space allowing to emulate only host architectures.
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

    virtualisation.libvirtd.qemuRunAsRoot = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If true,  libvirtd runs qemu as root.
        If false, libvirtd runs qemu as unprivileged user qemu-libvirtd.
        Changing this option to false may cause file permission issues
        for existing guests. To fix these, manually change ownership
        of affected files in /var/lib/libvirt/qemu to qemu-libvirtd.
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

    environment.systemPackages = with pkgs; [ libvirt libressl.nc cfg.qemuPackage ];

    boot.kernelModules = [ "tun" ];

    users.groups.libvirtd.gid = config.ids.gids.libvirtd;

    # libvirtd runs qemu as this user and group by default
    users.extraGroups.qemu-libvirtd.gid = config.ids.gids.qemu-libvirtd;
    users.extraUsers.qemu-libvirtd = {
      uid = config.ids.uids.qemu-libvirtd;
      isNormalUser = false;
      group = "qemu-libvirtd";
    };

    systemd.packages = [ pkgs.libvirt ];

    systemd.services.libvirtd = {
      description = "Libvirt Virtual Machine Management Daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ]
              ++ optional vswitch.enable "vswitchd.service";

      environment.LIBVIRTD_ARGS = ''--config "${configFile}" ${concatStringsSep " " cfg.extraOptions}'';

      path = [ cfg.qemuPackage ] # libvirtd requires qemu-img to manage disk images
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

        # stable (not GC'able as in /nix/store) paths for using in <emulator> section of xml configs
        mkdir -p /run/libvirt/nix-emulators
        for emulator in ${pkgs.libvirt}/libexec/libvirt_lxc ${cfg.qemuPackage}/bin/qemu-kvm ${cfg.qemuPackage}/bin/qemu-system-*; do
          ln -s --force "$emulator" /run/libvirt/nix-emulators/
        done

        ${optionalString cfg.qemuOvmf ''
            mkdir -p /run/libvirt/nix-ovmf
            ln -s --force ${pkgs.OVMF.fd}/FV/OVMF_CODE.fd /run/libvirt/nix-ovmf/
            ln -s --force ${pkgs.OVMF.fd}/FV/OVMF_VARS.fd /run/libvirt/nix-ovmf/
        ''}
      '';

      serviceConfig = {
        Type = "notify";
        KillMode = "process"; # when stopping, leave the VMs alone
        Restart = "no";
      };
      restartIfChanged = false;
    };

    systemd.services.libvirt-guests = {
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ coreutils libvirt gawk ];
      restartIfChanged = false;
    };

    systemd.sockets.virtlogd = {
      description = "Virtual machine log manager socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "/run/libvirt/virtlogd-sock" ];
    };

    systemd.services.virtlogd = {
      description = "Virtual machine log manager";
      serviceConfig.ExecStart = "@${pkgs.libvirt}/sbin/virtlogd virtlogd";
      restartIfChanged = false;
    };

    systemd.sockets.virtlockd = {
      description = "Virtual machine lock manager socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "/run/libvirt/virtlockd-sock" ];
    };

    systemd.services.virtlockd = {
      description = "Virtual machine lock manager";
      serviceConfig.ExecStart = "@${pkgs.libvirt}/sbin/virtlockd virtlockd";
      restartIfChanged = false;
    };
  };
}
