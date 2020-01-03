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
  dirName = "libvirt";
  subDirs = list: [ dirName ] ++ map (e: "${dirName}/${e}") list;

in {

  imports = [
    (mkRemovedOptionModule [ "virtualisation" "libvirtd" "enableKVM" ]
      "Set the option `virtualisation.libvirtd.qemuPackage' instead.")
  ];

  ###### interface

  options.virtualisation.libvirtd = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This option enables libvirtd, a daemon that manages
        virtual machines. Users in the "libvirtd" group can interact with
        the daemon (e.g. to start or stop VMs) using the
        <command>virsh</command> command line tool, among others.
      '';
    };

    qemuPackage = mkOption {
      type = types.package;
      default = pkgs.qemu;
      description = ''
        Qemu package to use with libvirt.
        `pkgs.qemu` can emulate alien architectures (e.g. aarch64 on x86)
        `pkgs.qemu_kvm` saves disk space allowing to emulate only host architectures.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra contents appended to the libvirtd configuration file,
        libvirtd.conf.
      '';
    };

    qemuRunAsRoot = mkOption {
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

    qemuVerbatimConfig = mkOption {
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

    qemuOvmf = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Allows libvirtd to take advantage of OVMF when creating new
        QEMU VMs with UEFI boot.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--verbose" ];
      description = ''
        Extra command line arguments passed to libvirtd on startup.
      '';
    };

    onBoot = mkOption {
      type = types.enum ["start" "ignore" ];
      default = "start";
      description = ''
        Specifies the action to be done to / on the guests when the host boots.
        The "start" option starts all guests that were running prior to shutdown
        regardless of their autostart settings. The "ignore" option will not
        start the formally running guest on boot. However, any guest marked as
        autostart will still be automatically started by libvirtd.
      '';
    };

    onShutdown = mkOption {
      type = types.enum ["shutdown" "suspend" ];
      default = "suspend";
      description = ''
        When shutting down / restarting the host what method should
        be used to gracefully halt the guests. Setting to "shutdown"
        will cause an ACPI shutdown of each guest. "suspend" will
        attempt to save the state of the guests ready to restore on boot.
      '';
    };

    allowedBridges = mkOption {
      type = types.listOf types.str;
      default = [ "virbr0" ];
      description = ''
        List of bridge devices that can be used by qemu:///session
      '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment = {
      # this file is expected in /etc/qemu and not sysconfdir (/var/lib)
      etc."qemu/bridge.conf".text = lib.concatMapStringsSep "\n" (e:
        "allow ${e}") cfg.allowedBridges;
      systemPackages = with pkgs; [ libvirt libressl.nc iptables cfg.qemuPackage ];
      etc.ethertypes.source = "${pkgs.iptables}/etc/ethertypes";
    };

    boot.kernelModules = [ "tun" ];

    users.groups.libvirtd.gid = config.ids.gids.libvirtd;

    # libvirtd runs qemu as this user and group by default
    users.extraGroups.qemu-libvirtd.gid = config.ids.gids.qemu-libvirtd;
    users.extraUsers.qemu-libvirtd = {
      uid = config.ids.uids.qemu-libvirtd;
      isNormalUser = false;
      group = "qemu-libvirtd";
    };

    security.wrappers.qemu-bridge-helper = {
      source = "/run/${dirName}/nix-helpers/qemu-bridge-helper";
    };

    systemd.packages = [ pkgs.libvirt ];

    systemd.services.libvirtd-config = {
      description = "Libvirt Virtual Machine Management Daemon - configuration";
      script = ''
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
        cp -f ${qemuConfigFile} /var/lib/${dirName}/qemu.conf

        # stable (not GC'able as in /nix/store) paths for using in <emulator> section of xml configs
        for emulator in ${pkgs.libvirt}/libexec/libvirt_lxc ${cfg.qemuPackage}/bin/qemu-kvm ${cfg.qemuPackage}/bin/qemu-system-*; do
          ln -s --force "$emulator" /run/${dirName}/nix-emulators/
        done

        for helper in libexec/qemu-bridge-helper bin/qemu-pr-helper; do
          ln -s --force ${cfg.qemuPackage}/$helper /run/${dirName}/nix-helpers/
        done

        ${optionalString cfg.qemuOvmf ''
          ln -s --force ${pkgs.OVMF.fd}/FV/OVMF_CODE.fd /run/${dirName}/nix-ovmf/
          ln -s --force ${pkgs.OVMF.fd}/FV/OVMF_VARS.fd /run/${dirName}/nix-ovmf/
        ''}
      '';

      serviceConfig = {
        Type = "oneshot";
        RuntimeDirectoryPreserve = "yes";
        LogsDirectory = subDirs [ "qemu" ];
        RuntimeDirectory = subDirs [ "nix-emulators" "nix-helpers" "nix-ovmf" ];
        StateDirectory = subDirs [ "dnsmasq" ];
      };
    };

    systemd.services.libvirtd = {
      description = "Libvirt Virtual Machine Management Daemon";

      wantedBy = [ "multi-user.target" ];
      requires = [ "libvirtd-config.service" ];
      after = [ "systemd-udev-settle.service" "libvirtd-config.service" ]
              ++ optional vswitch.enable "vswitchd.service";

      environment.LIBVIRTD_ARGS = ''--config "${configFile}" ${concatStringsSep " " cfg.extraOptions}'';

      path = [ cfg.qemuPackage ] # libvirtd requires qemu-img to manage disk images
             ++ optional vswitch.enable vswitch.package;

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

      environment.ON_BOOT = "${cfg.onBoot}";
      environment.ON_SHUTDOWN = "${cfg.onShutdown}";
    };

    systemd.sockets.virtlogd = {
      description = "Virtual machine log manager socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "/run/${dirName}/virtlogd-sock" ];
    };

    systemd.services.virtlogd = {
      description = "Virtual machine log manager";
      serviceConfig.ExecStart = "@${pkgs.libvirt}/sbin/virtlogd virtlogd";
      restartIfChanged = false;
    };

    systemd.sockets.virtlockd = {
      description = "Virtual machine lock manager socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "/run/${dirName}/virtlockd-sock" ];
    };

    systemd.services.virtlockd = {
      description = "Virtual machine lock manager";
      serviceConfig.ExecStart = "@${pkgs.libvirt}/sbin/virtlockd virtlockd";
      restartIfChanged = false;
    };
  };
}
