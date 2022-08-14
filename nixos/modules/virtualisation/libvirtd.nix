{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.libvirtd;
  vswitch = config.virtualisation.vswitch;
  configFile = pkgs.writeText "libvirtd.conf" ''
    auth_unix_ro = "polkit"
    auth_unix_rw = "polkit"
    ${cfg.extraConfig}
  '';
  qemuConfigFile = pkgs.writeText "qemu.conf" ''
    ${optionalString cfg.qemu.ovmf.enable ''
      nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
    ''}
    ${optionalString (!cfg.qemu.runAsRoot) ''
      user = "qemu-libvirtd"
      group = "qemu-libvirtd"
    ''}
    ${cfg.qemu.verbatimConfig}
  '';
  dirName = "libvirt";
  subDirs = list: [ dirName ] ++ map (e: "${dirName}/${e}") list;

  ovmfModule = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Allows libvirtd to take advantage of OVMF when creating new
          QEMU VMs with UEFI boot.
        '';
      };

      # mkRemovedOptionModule does not work in submodules, do it manually
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        internal = true;
      };

      packages = mkOption {
        type = types.listOf types.package;
        default = [ pkgs.OVMF.fd ];
        defaultText = literalExpression "[ pkgs.OVMF.fd ]";
        example = literalExpression "[ pkgs.OVMFFull.fd pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd ]";
        description = lib.mdDoc ''
          List of OVMF packages to use. Each listed package must contain files names FV/OVMF_CODE.fd and FV/OVMF_VARS.fd or FV/AAVMF_CODE.fd and FV/AAVMF_VARS.fd
        '';
      };
    };
  };

  swtpmModule = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Allows libvirtd to use swtpm to create an emulated TPM.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.swtpm;
        defaultText = literalExpression "pkgs.swtpm";
        description = lib.mdDoc ''
          swtpm package to use.
        '';
      };
    };
  };

  qemuModule = types.submodule {
    options = {
      package = mkOption {
        type = types.package;
        default = pkgs.qemu;
        defaultText = literalExpression "pkgs.qemu";
        description = lib.mdDoc ''
          Qemu package to use with libvirt.
          `pkgs.qemu` can emulate alien architectures (e.g. aarch64 on x86)
          `pkgs.qemu_kvm` saves disk space allowing to emulate only host architectures.
        '';
      };

      runAsRoot = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          If true,  libvirtd runs qemu as root.
          If false, libvirtd runs qemu as unprivileged user qemu-libvirtd.
          Changing this option to false may cause file permission issues
          for existing guests. To fix these, manually change ownership
          of affected files in /var/lib/libvirt/qemu to qemu-libvirtd.
        '';
      };

      verbatimConfig = mkOption {
        type = types.lines;
        default = ''
          namespaces = []
        '';
        description = lib.mdDoc ''
          Contents written to the qemu configuration file, qemu.conf.
          Make sure to include a proper namespace configuration when
          supplying custom configuration.
        '';
      };

      ovmf = mkOption {
        type = ovmfModule;
        default = { };
        description = lib.mdDoc ''
          QEMU's OVMF options.
        '';
      };

      swtpm = mkOption {
        type = swtpmModule;
        default = { };
        description = lib.mdDoc ''
          QEMU's swtpm options.
        '';
      };
    };
  };
in
{

  imports = [
    (mkRemovedOptionModule [ "virtualisation" "libvirtd" "enableKVM" ]
      "Set the option `virtualisation.libvirtd.qemu.package' instead.")
    (mkRenamedOptionModule
      [ "virtualisation" "libvirtd" "qemuPackage" ]
      [ "virtualisation" "libvirtd" "qemu" "package" ])
    (mkRenamedOptionModule
      [ "virtualisation" "libvirtd" "qemuRunAsRoot" ]
      [ "virtualisation" "libvirtd" "qemu" "runAsRoot" ])
    (mkRenamedOptionModule
      [ "virtualisation" "libvirtd" "qemuVerbatimConfig" ]
      [ "virtualisation" "libvirtd" "qemu" "verbatimConfig" ])
    (mkRenamedOptionModule
      [ "virtualisation" "libvirtd" "qemuOvmf" ]
      [ "virtualisation" "libvirtd" "qemu" "ovmf" "enable" ])
    (mkRemovedOptionModule
      [ "virtualisation" "libvirtd" "qemuOvmfPackage" ]
      "If this option was set to `foo`, set the option `virtualisation.libvirtd.qemu.ovmf.packages' to `[foo.fd]` instead.")
    (mkRenamedOptionModule
      [ "virtualisation" "libvirtd" "qemuSwtpm" ]
      [ "virtualisation" "libvirtd" "qemu" "swtpm" "enable" ])
  ];

  ###### interface

  options.virtualisation.libvirtd = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        This option enables libvirtd, a daemon that manages
        virtual machines. Users in the "libvirtd" group can interact with
        the daemon (e.g. to start or stop VMs) using the
        {command}`virsh` command line tool, among others.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.libvirt;
      defaultText = literalExpression "pkgs.libvirt";
      description = lib.mdDoc ''
        libvirt package to use.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra contents appended to the libvirtd configuration file,
        libvirtd.conf.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--verbose" ];
      description = lib.mdDoc ''
        Extra command line arguments passed to libvirtd on startup.
      '';
    };

    onBoot = mkOption {
      type = types.enum [ "start" "ignore" ];
      default = "start";
      description = lib.mdDoc ''
        Specifies the action to be done to / on the guests when the host boots.
        The "start" option starts all guests that were running prior to shutdown
        regardless of their autostart settings. The "ignore" option will not
        start the formerly running guest on boot. However, any guest marked as
        autostart will still be automatically started by libvirtd.
      '';
    };

    onShutdown = mkOption {
      type = types.enum [ "shutdown" "suspend" ];
      default = "suspend";
      description = lib.mdDoc ''
        When shutting down / restarting the host what method should
        be used to gracefully halt the guests. Setting to "shutdown"
        will cause an ACPI shutdown of each guest. "suspend" will
        attempt to save the state of the guests ready to restore on boot.
      '';
    };

    allowedBridges = mkOption {
      type = types.listOf types.str;
      default = [ "virbr0" ];
      description = lib.mdDoc ''
        List of bridge devices that can be used by qemu:///session
      '';
    };

    qemu = mkOption {
      type = qemuModule;
      default = { };
      description = lib.mdDoc ''
        QEMU related options.
      '';
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = config.virtualisation.libvirtd.qemu.ovmf.package == null;
        message = ''
        The option virtualisation.libvirtd.qemu.ovmf.package is superseded by virtualisation.libvirtd.qemu.ovmf.packages.
        If this option was set to `foo`, set the option `virtualisation.libvirtd.qemu.ovmf.packages' to `[foo.fd]` instead.
        '';
      }
      {
        assertion = config.security.polkit.enable;
        message = "The libvirtd module currently requires Polkit to be enabled ('security.polkit.enable = true').";
      }
    ];

    environment = {
      # this file is expected in /etc/qemu and not sysconfdir (/var/lib)
      etc."qemu/bridge.conf".text = lib.concatMapStringsSep "\n"
        (e:
          "allow ${e}")
        cfg.allowedBridges;
      systemPackages = with pkgs; [ libressl.nc iptables cfg.package cfg.qemu.package ];
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
      setuid = true;
      owner = "root";
      group = "root";
      source = "/run/${dirName}/nix-helpers/qemu-bridge-helper";
    };

    systemd.packages = [ cfg.package ];

    systemd.services.libvirtd-config = {
      description = "Libvirt Virtual Machine Management Daemon - configuration";
      script = ''
        # Copy default libvirt network config .xml files to /var/lib
        # Files modified by the user will not be overwritten
        for i in $(cd ${cfg.package}/var/lib && echo \
            libvirt/qemu/networks/*.xml \
            libvirt/nwfilter/*.xml );
        do
            mkdir -p /var/lib/$(dirname $i) -m 755
            cp -npd ${cfg.package}/var/lib/$i /var/lib/$i
        done

        # Copy generated qemu config to libvirt directory
        cp -f ${qemuConfigFile} /var/lib/${dirName}/qemu.conf

        # stable (not GC'able as in /nix/store) paths for using in <emulator> section of xml configs
        for emulator in ${cfg.package}/libexec/libvirt_lxc ${cfg.qemu.package}/bin/qemu-kvm ${cfg.qemu.package}/bin/qemu-system-*; do
          ln -s --force "$emulator" /run/${dirName}/nix-emulators/
        done

        for helper in libexec/qemu-bridge-helper bin/qemu-pr-helper; do
          ln -s --force ${cfg.qemu.package}/$helper /run/${dirName}/nix-helpers/
        done

        ${optionalString cfg.qemu.ovmf.enable (let
          ovmfpackage = pkgs.buildEnv {
            name = "qemu-ovmf";
            paths = cfg.qemu.ovmf.packages;
          };
        in
          ''
          ln -s --force ${ovmfpackage}/FV/AAVMF_CODE.fd /run/${dirName}/nix-ovmf/
          ln -s --force ${ovmfpackage}/FV/OVMF_CODE.fd /run/${dirName}/nix-ovmf/
          ln -s --force ${ovmfpackage}/FV/AAVMF_VARS.fd /run/${dirName}/nix-ovmf/
          ln -s --force ${ovmfpackage}/FV/OVMF_VARS.fd /run/${dirName}/nix-ovmf/
        '')}
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
      requires = [ "libvirtd-config.service" ];
      after = [ "libvirtd-config.service" ]
        ++ optional vswitch.enable "ovs-vswitchd.service";

      environment.LIBVIRTD_ARGS = escapeShellArgs (
        [
          "--config"
          configFile
          "--timeout"
          "120" # from ${libvirt}/var/lib/sysconfig/libvirtd
        ] ++ cfg.extraOptions
      );

      path = [ cfg.qemu.package ] # libvirtd requires qemu-img to manage disk images
        ++ optional vswitch.enable vswitch.package
        ++ optional cfg.qemu.swtpm.enable cfg.qemu.swtpm.package;

      serviceConfig = {
        Type = "notify";
        KillMode = "process"; # when stopping, leave the VMs alone
        Restart = "no";
      };
      restartIfChanged = false;
    };

    systemd.services.virtchd = {
      path = [ pkgs.cloud-hypervisor ];
    };

    systemd.services.libvirt-guests = {
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ coreutils gawk cfg.package ];
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
      serviceConfig.ExecStart = "@${cfg.package}/sbin/virtlogd virtlogd";
      restartIfChanged = false;
    };

    systemd.sockets.virtlockd = {
      description = "Virtual machine lock manager socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "/run/${dirName}/virtlockd-sock" ];
    };

    systemd.services.virtlockd = {
      description = "Virtual machine lock manager";
      serviceConfig.ExecStart = "@${cfg.package}/sbin/virtlockd virtlockd";
      restartIfChanged = false;
    };

    # https://libvirt.org/daemons.html#monolithic-systemd-integration
    systemd.sockets.libvirtd.wantedBy = [ "sockets.target" ];

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.libvirt.unix.manage" &&
          subject.isInGroup("libvirtd")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
