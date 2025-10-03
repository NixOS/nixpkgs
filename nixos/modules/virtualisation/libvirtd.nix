{
  config,
  lib,
  pkgs,
  ...
}:

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
    ${optionalString (!cfg.qemu.runAsRoot) ''
      user = "qemu-libvirtd"
      group = "qemu-libvirtd"
    ''}
    ${cfg.qemu.verbatimConfig}
  '';
  networkConfigFile = pkgs.writeText "network.conf" ''
    firewall_backend = "${cfg.firewallBackend}"
  '';

  dirName = "libvirt";
  subDirs = list: [ dirName ] ++ map (e: "${dirName}/${e}") list;

  swtpmModule = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Allows libvirtd to use swtpm to create an emulated TPM.
        '';
      };

      package = mkPackageOption pkgs "swtpm" { };
    };
  };

  qemuModule = types.submodule {
    options = {
      package = mkPackageOption pkgs "qemu" {
        extraDescription = ''
          `pkgs.qemu` can emulate alien architectures (e.g. aarch64 on x86)
          `pkgs.qemu_kvm` saves disk space allowing to emulate only host architectures.
        '';
      };

      runAsRoot = mkOption {
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

      verbatimConfig = mkOption {
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

      ovmf = mkOption {
        type = types.submodule {
          options = {
            enable = mkOption {
              type = types.nullOr types.bool;
              default = null;
              internal = true;
            };
            package = mkOption {
              type = types.nullOr types.package;
              default = null;
              internal = true;
            };
            packages = mkOption {
              type = types.nullOr (types.listOf types.package);
              default = null;
              internal = true;
            };
          };
        };
        default = { };
        internal = true;
        description = "This submodule is deprecated and has been removed";
      };

      swtpm = mkOption {
        type = swtpmModule;
        default = { };
        description = ''
          QEMU's swtpm options.
        '';
      };

      vhostUserPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.virtiofsd ]";
        description = ''
          Packages containing out-of-tree vhost-user drivers.
        '';
      };
    };
  };

  hooksModule = types.submodule {
    options = {
      daemon = mkOption {
        type = types.attrsOf types.path;
        default = { };
        description = ''
          Hooks that will be placed under /var/lib/libvirt/hooks/daemon.d/
          and called for daemon start/shutdown/SIGHUP events.
          Please see <https://libvirt.org/hooks.html> for documentation.
        '';
      };

      qemu = mkOption {
        type = types.attrsOf types.path;
        default = { };
        description = ''
          Hooks that will be placed under /var/lib/libvirt/hooks/qemu.d/
          and called for qemu domains begin/end/migrate events.
          Please see <https://libvirt.org/hooks.html> for documentation.
        '';
      };

      lxc = mkOption {
        type = types.attrsOf types.path;
        default = { };
        description = ''
          Hooks that will be placed under /var/lib/libvirt/hooks/lxc.d/
          and called for lxc domains begin/end events.
          Please see <https://libvirt.org/hooks.html> for documentation.
        '';
      };

      libxl = mkOption {
        type = types.attrsOf types.path;
        default = { };
        description = ''
          Hooks that will be placed under /var/lib/libvirt/hooks/libxl.d/
          and called for libxl-handled xen domains begin/end events.
          Please see <https://libvirt.org/hooks.html> for documentation.
        '';
      };

      network = mkOption {
        type = types.attrsOf types.path;
        default = { };
        description = ''
          Hooks that will be placed under /var/lib/libvirt/hooks/network.d/
          and called for networks begin/end events.
          Please see <https://libvirt.org/hooks.html> for documentation.
        '';
      };
    };
  };

  nssModule = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          This option enables the older libvirt NSS module. This method uses
          DHCP server records, therefore is dependent on the hostname provided
          by the guest.
          Please see <https://libvirt.org/nss.html> for more information.
        '';
      };

      enableGuest = mkOption {
        type = types.bool;
        default = false;
        description = ''
          This option enables the newer libvirt_guest NSS module. This module
          uses the libvirt guest name instead of the hostname of the guest.
          Please see <https://libvirt.org/nss.html> for more information.
        '';
      };
    };
  };

  qemuOvmfMetadata = pkgs.stdenv.mkDerivation {
    name = "qemu-ovmf-metadata";
    version = cfg.qemu.package.version;
    nativeBuildInputs = [ cfg.qemu.package ];
    dontBuild = true;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out
      cp ${cfg.qemu.package}/share/qemu/firmware/*.json $out
      substituteInPlace $out/*.json \
        --replace-fail "${cfg.qemu.package}/share/qemu/" "/run/${dirName}/nix-ovmf/"
    '';
  };

in
{

  imports = [
    (mkRemovedOptionModule [
      "virtualisation"
      "libvirtd"
      "enableKVM"
    ] "Set the option `virtualisation.libvirtd.qemu.package' instead.")
    (mkRenamedOptionModule
      [ "virtualisation" "libvirtd" "qemuPackage" ]
      [ "virtualisation" "libvirtd" "qemu" "package" ]
    )
    (mkRenamedOptionModule
      [ "virtualisation" "libvirtd" "qemuRunAsRoot" ]
      [ "virtualisation" "libvirtd" "qemu" "runAsRoot" ]
    )
    (mkRenamedOptionModule
      [ "virtualisation" "libvirtd" "qemuVerbatimConfig" ]
      [ "virtualisation" "libvirtd" "qemu" "verbatimConfig" ]
    )
    (mkRenamedOptionModule
      [ "virtualisation" "libvirtd" "qemuSwtpm" ]
      [ "virtualisation" "libvirtd" "qemu" "swtpm" "enable" ]
    )
    (mkRemovedOptionModule [ "virtualisation" "libvirtd" "qemuOvmf" ]
      "The 'virtualisation.libvirtd.qemuOvmf' option has been removed. All OVMF images distributed with QEMU are now available by default."
    )
    (mkRemovedOptionModule [ "virtualisation" "libvirtd" "qemuOvmfPackage" ]
      "The 'virtualisation.libvirtd.qemuOvmfPackage' option has been removed. All OVMF images distributed with QEMU are now available by default."
    )
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
        {command}`virsh` command line tool, among others.
      '';
    };

    package = mkPackageOption pkgs "libvirt" { };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra contents appended to the libvirtd configuration file,
        libvirtd.conf.
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
      type = types.enum [
        "start"
        "ignore"
      ];
      default = "start";
      description = ''
        Specifies the action to be done to / on the guests when the host boots.
        The "start" option starts all guests that were running prior to shutdown
        regardless of their autostart settings. The "ignore" option will not
        start the formerly running guest on boot. However, any guest marked as
        autostart will still be automatically started by libvirtd.
      '';
    };

    onShutdown = mkOption {
      type = types.enum [
        "shutdown"
        "suspend"
      ];
      default = "suspend";
      description = ''
        When shutting down / restarting the host what method should
        be used to gracefully halt the guests. Setting to "shutdown"
        will cause an ACPI shutdown of each guest. "suspend" will
        attempt to save the state of the guests ready to restore on boot.
      '';
    };

    parallelShutdown = mkOption {
      type = types.ints.unsigned;
      default = 0;
      description = ''
        Number of guests that will be shutdown concurrently, taking effect when onShutdown
        is set to "shutdown". If set to 0, guests will be shutdown one after another.
        Number of guests on shutdown at any time will not exceed number set in this
        variable.
      '';
    };

    shutdownTimeout = mkOption {
      type = types.ints.unsigned;
      default = 300;
      description = ''
        Number of seconds we're willing to wait for a guest to shut down.
        If parallel shutdown is enabled, this timeout applies as a timeout
        for shutting down all guests on a single URI defined in the variable URIS.
        If this is 0, then there is no time out (use with caution, as guests might not
        respond to a shutdown request).
      '';
    };

    startDelay = mkOption {
      type = types.ints.unsigned;
      default = 0;
      description = ''
        Number of seconds to wait between each guest start.
        If set to 0, all guests will start up in parallel.
      '';
    };

    allowedBridges = mkOption {
      type = types.listOf types.str;
      default = [ "virbr0" ];
      description = ''
        List of bridge devices that can be used by qemu:///session
      '';
    };

    qemu = mkOption {
      type = qemuModule;
      default = { };
      description = ''
        QEMU related options.
      '';
    };

    hooks = mkOption {
      type = hooksModule;
      default = { };
      description = ''
        Hooks related options.
      '';
    };

    nss = mkOption {
      type = nssModule;
      default = { };
      description = ''
        libvirt NSS module options.
      '';
    };

    sshProxy = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to configure OpenSSH to use the [SSH Proxy](https://libvirt.org/ssh-proxy.html).
      '';
    };

    firewallBackend = mkOption {
      type = types.enum [
        "iptables"
        "nftables"
      ];
      default = if config.networking.nftables.enable then "nftables" else "iptables";
      defaultText = lib.literalExpression "if config.networking.nftables.enable then \"nftables\" else \"iptables\"";
      description = ''
        The backend used to setup virtual network firewall rules.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = config.security.polkit.enable;
        message = "The libvirtd module currently requires Polkit to be enabled ('security.polkit.enable = true').";
      }

      {
        assertion = ((lib.filterAttrs (n: v: v != null) cfg.qemu.ovmf) == { });
        message = "The 'virtualisation.libvirtd.qemu.ovmf' submodule has been removed. All OVMF images distributed with QEMU are now available by default.";
      }
    ];

    environment = {
      # this file is expected in /etc/qemu and not sysconfdir (/var/lib)
      etc."qemu/bridge.conf".text = lib.concatMapStringsSep "\n" (e: "allow ${e}") cfg.allowedBridges;
      systemPackages = with pkgs; [
        libressl.nc
        config.networking.firewall.package
        cfg.package
        cfg.qemu.package
      ];
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
      source = "${cfg.qemu.package}/libexec/qemu-bridge-helper";
    };

    programs.ssh.extraConfig = mkIf cfg.sshProxy ''
      Include ${cfg.package}/etc/ssh/ssh_config.d/30-libvirt-ssh-proxy.conf
    '';

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
            # Intended behavior
            # shellcheck disable=SC2174
            mkdir -p "/var/lib/$(dirname "$i")" -m 755
            if [ ! -e "/var/lib/$i" ]; then
              cp -pd "${cfg.package}/var/lib/$i" "/var/lib/$i"
            fi
        done

        # Copy generated qemu config to libvirt directory
        cp -f ${qemuConfigFile} /var/lib/${dirName}/qemu.conf

        # Copy generated network config to libvirt directory
        cp -f ${networkConfigFile} /var/lib/${dirName}/network.conf

        # stable (not GC'able as in /nix/store) paths for using in <emulator> section of xml configs
        for emulator in ${cfg.package}/libexec/libvirt_lxc ${cfg.qemu.package}/bin/qemu-kvm ${cfg.qemu.package}/bin/qemu-system-*; do
          ln -s --force "$emulator" /run/${dirName}/nix-emulators/
        done

        ln -s --force ${cfg.qemu.package}/bin/qemu-pr-helper /run/${dirName}/nix-helpers/

        # Symlink to OVMF firmware code and variable template images distributed with QEMU
        cp -sfv $(
          ${pkgs.jq}/bin/jq -rs \
            '[.[] | .mapping.executable.filename, .mapping."nvram-template".filename] | unique | .[]' \
          ${cfg.qemu.package}/share/qemu/firmware/* \
        ) /run/${dirName}/nix-ovmf

        # Symlink hooks to /var/lib/libvirt
        ${concatStringsSep "\n" (
          map (driver: ''
            mkdir -p /var/lib/${dirName}/hooks/${driver}.d
            rm -rf /var/lib/${dirName}/hooks/${driver}.d/*
            ${concatStringsSep "\n" (
              mapAttrsToList (
                name: value: "ln -s --force ${value} /var/lib/${dirName}/hooks/${driver}.d/${name}"
              ) cfg.hooks.${driver}
            )}
          '') (attrNames cfg.hooks)
        )}
      '';

      serviceConfig = {
        Type = "oneshot";
        RuntimeDirectoryPreserve = "yes";
        LogsDirectory = subDirs [ "qemu" ];
        RuntimeDirectory = subDirs [
          "nix-emulators"
          "nix-helpers"
          "nix-ovmf"
        ];
        StateDirectory = subDirs [ "dnsmasq" ];
      };
    };

    systemd.services.libvirtd = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "libvirtd-config.service" ];
      after = [ "libvirtd-config.service" ] ++ optional vswitch.enable "ovs-vswitchd.service";

      environment.LIBVIRTD_ARGS = escapeShellArgs (
        [
          "--config"
          configFile
          "--timeout"
          "120" # from ${libvirt}/var/lib/sysconfig/libvirtd
        ]
        ++ cfg.extraOptions
      );

      path = [
        cfg.qemu.package
        pkgs.netcat
      ] # libvirtd requires qemu-img to manage disk images
      ++ optional vswitch.enable vswitch.package
      ++ optional cfg.qemu.swtpm.enable cfg.qemu.swtpm.package;

      serviceConfig = {
        Type = "notify";
        KillMode = "process"; # when stopping, leave the VMs alone
        Restart = "no";
        OOMScoreAdjust = "-999";
      };
      restartIfChanged = false;
    };

    systemd.services.virtchd = {
      path = [ pkgs.cloud-hypervisor ];
    };

    systemd.services.libvirt-guests = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "libvirtd.service" ];
      after = [ "libvirtd.service" ];
      path = with pkgs; [
        coreutils
        gawk
        cfg.package
      ];
      restartIfChanged = false;

      environment.ON_BOOT = "${cfg.onBoot}";
      environment.ON_SHUTDOWN = "${cfg.onShutdown}";
      environment.PARALLEL_SHUTDOWN = "${toString cfg.parallelShutdown}";
      environment.SHUTDOWN_TIMEOUT = "${toString cfg.shutdownTimeout}";
      environment.START_DELAY = "${toString cfg.startDelay}";
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

    systemd.tmpfiles.rules =
      let
        vhostUserCollection = pkgs.buildEnv {
          name = "vhost-user";
          paths = cfg.qemu.vhostUserPackages;
          pathsToLink = [ "/share/qemu/vhost-user" ];
        };
      in
      [
        "L+ /var/lib/qemu/vhost-user - - - - ${vhostUserCollection}/share/qemu/vhost-user"
        "L+ /var/lib/qemu/firmware - - - - ${qemuOvmfMetadata}"
      ];

    security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.libvirt.unix.manage" &&
            subject.isInGroup("libvirtd")) {
            return polkit.Result.YES;
          }
        });
      '';
    };

    system.nssModules = optional (cfg.nss.enable or cfg.nss.enableGuest) cfg.package;
    system.nssDatabases.hosts = mkMerge [
      # ensure that the NSS modules come between mymachines (which is 400) and resolve (which is 501)
      (mkIf cfg.nss.enable (mkOrder 430 [ "libvirt" ]))
      (mkIf cfg.nss.enableGuest (mkOrder 432 [ "libvirt_guest" ]))
    ];
  };
}
