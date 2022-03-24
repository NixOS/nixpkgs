{ lib, config, utils, pkgs, ... }:

with lib;

let
  inherit (utils) systemdUtils escapeSystemdPath;
  inherit (systemdUtils.lib)
    generateUnits
    pathToUnit
    serviceToUnit
    sliceToUnit
    socketToUnit
    targetToUnit
    timerToUnit
    mountToUnit
    automountToUnit;


  cfg = config.boot.initrd.systemd;

  # Copied from fedora
  upstreamUnits = [
    "basic.target"
    "ctrl-alt-del.target"
    "emergency.service"
    "emergency.target"
    "final.target"
    "halt.target"
    "initrd-cleanup.service"
    "initrd-fs.target"
    "initrd-parse-etc.service"
    "initrd-root-device.target"
    "initrd-root-fs.target"
    "initrd-switch-root.service"
    "initrd-switch-root.target"
    "initrd.target"
    "initrd-udevadm-cleanup-db.service"
    "kexec.target"
    "kmod-static-nodes.service"
    "local-fs-pre.target"
    "local-fs.target"
    "multi-user.target"
    "paths.target"
    "poweroff.target"
    "reboot.target"
    "rescue.service"
    "rescue.target"
    "rpcbind.target"
    "shutdown.target"
    "sigpwr.target"
    "slices.target"
    "sockets.target"
    "swap.target"
    "sysinit.target"
    "sys-kernel-config.mount"
    "syslog.socket"
    "systemd-ask-password-console.path"
    "systemd-ask-password-console.service"
    "systemd-fsck@.service"
    "systemd-halt.service"
    "systemd-hibernate-resume@.service"
    "systemd-journald-audit.socket"
    "systemd-journald-dev-log.socket"
    "systemd-journald.service"
    "systemd-journald.socket"
    "systemd-kexec.service"
    "systemd-modules-load.service"
    "systemd-poweroff.service"
    "systemd-random-seed.service"
    "systemd-reboot.service"
    "systemd-sysctl.service"
    "systemd-tmpfiles-setup-dev.service"
    "systemd-tmpfiles-setup.service"
    "systemd-udevd-control.socket"
    "systemd-udevd-kernel.socket"
    "systemd-udevd.service"
    "systemd-udev-settle.service"
    "systemd-udev-trigger.service"
    "systemd-vconsole-setup.service"
    "timers.target"
    "umount.target"

    # TODO: Networking
    # "network-online.target"
    # "network-pre.target"
    # "network.target"
    # "nss-lookup.target"
    # "nss-user-lookup.target"
    # "remote-fs-pre.target"
    # "remote-fs.target"
  ] ++ cfg.additionalUpstreamUnits;

  upstreamWants = [
    "sysinit.target.wants"
  ];

  enabledUpstreamUnits = filter (n: ! elem n cfg.suppressedUnits) upstreamUnits;
  enabledUnits = filterAttrs (n: v: ! elem n cfg.suppressedUnits) cfg.units;

  stage1Units = generateUnits {
    type = "initrd";
    units = enabledUnits;
    upstreamUnits = enabledUpstreamUnits;
    inherit upstreamWants;
    inherit (cfg) packages package;
  };

  fileSystems = filter utils.fsNeededForBoot config.system.build.fileSystems;

  fstab = pkgs.writeText "fstab" (lib.concatMapStringsSep "\n"
    ({ fsType, mountPoint, device, options, autoFormat, autoResize, ... }@fs: let
        opts = options ++ optional autoFormat "x-systemd.makefs" ++ optional autoResize "x-systemd.growfs";
      in "${device} /sysroot${mountPoint} ${fsType} ${lib.concatStringsSep "," opts}") fileSystems);

  kernel-name = config.boot.kernelPackages.kernel.name or "kernel";
  modulesTree = config.system.modulesTree.override { name = kernel-name + "-modules"; };
  firmware = config.hardware.firmware;
  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = pkgs.makeModulesClosure {
    rootModules = config.boot.initrd.availableKernelModules ++ config.boot.initrd.kernelModules;
    kernel = modulesTree;
    firmware = firmware;
    allowMissing = false;
  };

  initrdBinEnv = pkgs.buildEnv {
    name = "initrd-emergency-env";
    paths = map getBin cfg.initrdBin;
    pathsToLink = ["/bin" "/sbin"];
  };

  initialRamdisk = pkgs.makeInitrdNG {
    contents = cfg.objects;
  };

in {
  options.boot.initrd.systemd = {
    enable = mkEnableOption ''systemd in initrd.

      Note: This is in very early development and is highly
      experimental. Most of the features NixOS supports in initrd are
      not yet supported by the intrd generated with this option.
    '';

    package = (lib.mkPackageOption pkgs "systemd" {
      default = "systemdMinimal";
    }) // {
      visible = false;
    };

    objects = mkOption {
      description = "List of objects to include in the initrd, and their symlinks";
      example = literalExpression ''
        [ { object = "''${systemd}/lib/systemd/systemd"; symlink = "/init"; } ]
      '';
      visible = false;
      type = types.listOf (types.submodule {
        options = {
          object = mkOption {
            type = types.path;
            description = "The object to include in initrd.";
          };
          symlink = mkOption {
            type = types.nullOr types.path;
            description = "A symlink to create in initrd pointing to the object.";
            default = null;
          };
        };
      });
    };

    emergencyHashedPassword = mkOption {
      type = types.str;
      visible = false;
      description = ''
        Hashed password for the super user account in stage 1 emergency mode

        Blank for no password, ! for super user disabled.
      '';
      default = "!";
    };

    initrdBin = mkOption {
      type = types.listOf types.package;
      default = [];
      visible = false;
      description = ''
        Packages to include in /bin for the stage 1 emergency shell.
      '';
    };

    additionalUpstreamUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      visible = false;
      example = [ "debug-shell.service" "systemd-quotacheck.service" ];
      description = ''
        Additional units shipped with systemd that shall be enabled.
      '';
    };

    suppressedUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [ "systemd-backlight@.service" ];
      visible = false;
      description = ''
        A list of units to skip when generating system systemd configuration directory. This has
        priority over upstream units, <option>boot.initrd.systemd.units</option>, and
        <option>boot.initrd.systemd.additionalUpstreamUnits</option>. The main purpose of this is to
        prevent a upstream systemd unit from being added to the initrd with any modifications made to it
        by other NixOS modules.
      '';
    };

    units = mkOption {
      description = "Definition of systemd units.";
      default = {};
      visible = false;
      type = systemdUtils.types.units;
    };

    packages = mkOption {
      default = [];
      visible = false;
      type = types.listOf types.package;
      example = literalExpression "[ pkgs.systemd-cryptsetup-generator ]";
      description = "Packages providing systemd units and hooks.";
    };

    targets = mkOption {
      default = {};
      visible = false;
      type = systemdUtils.types.targets;
      description = "Definition of systemd target units.";
    };

    services = mkOption {
      default = {};
      type = systemdUtils.types.initrdServices;
      visible = false;
      description = "Definition of systemd service units.";
    };

    sockets = mkOption {
      default = {};
      type = systemdUtils.types.sockets;
      visible = false;
      description = "Definition of systemd socket units.";
    };

    timers = mkOption {
      default = {};
      type = systemdUtils.types.timers;
      visible = false;
      description = "Definition of systemd timer units.";
    };

    paths = mkOption {
      default = {};
      type = systemdUtils.types.paths;
      visible = false;
      description = "Definition of systemd path units.";
    };

    mounts = mkOption {
      default = [];
      type = systemdUtils.types.mounts;
      visible = false;
      description = ''
        Definition of systemd mount units.
        This is a list instead of an attrSet, because systemd mandates the names to be derived from
        the 'where' attribute.
      '';
    };

    automounts = mkOption {
      default = [];
      type = systemdUtils.types.automounts;
      visible = false;
      description = ''
        Definition of systemd automount units.
        This is a list instead of an attrSet, because systemd mandates the names to be derived from
        the 'where' attribute.
      '';
    };

    slices = mkOption {
      default = {};
      type = systemdUtils.types.slices;
      visible = false;
      description = "Definition of slice configurations.";
    };
  };

  config = mkIf (config.boot.initrd.enable && cfg.enable) {
    system.build = { inherit initialRamdisk; };
    boot.initrd.systemd = {
      initrdBin = [pkgs.bash pkgs.coreutils pkgs.kmod cfg.package] ++ config.system.fsPackages;

      objects = [
        { object = "${cfg.package}/lib/systemd/systemd"; symlink = "/init"; }
        { object = stage1Units; symlink = "/etc/systemd/system"; }

        # TODO: Limit this to the bare necessities
        { object = "${cfg.package}/lib"; }

        { object = "${cfg.package.util-linux}/bin/mount"; }
        { object = "${cfg.package.util-linux}/bin/umount"; }
        { object = "${cfg.package.util-linux}/bin/sulogin"; }

        {
          object = builtins.toFile "system.conf" ''
            [Manager]
            DefaultEnvironment=PATH=/bin:/sbin
          '';
          symlink = "/etc/systemd/system.conf";
        }

        { object = config.environment.etc.os-release.source; symlink = "/etc/initrd-release"; }
        { object = config.environment.etc.os-release.source; symlink = "/etc/os-release"; }
        { object = fstab; symlink = "/etc/fstab"; }
        {
          object = "${modulesClosure}/lib/modules";
          symlink = "/lib/modules";
        }
        {
          symlink = "/etc/modules-load.d/nixos.conf";
          object = pkgs.writeText "nixos.conf"
            (lib.concatStringsSep "\n" config.boot.initrd.kernelModules);
        }

        { object = "${pkgs.fakeNss}/etc/passwd"; symlink = "/etc/passwd"; }
        # so NSS can look up usernames
        { object = "${pkgs.glibc}/lib/libnss_files.so"; }
        {
          object = builtins.toFile "shadow" "root:${config.boot.initrd.systemd.emergencyHashedPassword}:::::::";
          symlink = "/etc/shadow";
        }
        { object = "${initrdBinEnv}/bin"; symlink = "/bin"; }
        { object = "${initrdBinEnv}/sbin"; symlink = "/sbin"; }
        { object = builtins.toFile "sysctl.conf" "kernel.modprobe = /sbin/modprobe"; symlink = "/etc/sysctl.d/nixos.conf"; }
      ];

      targets.initrd.aliases = ["default.target"];
      units =
           mapAttrs' (n: v: nameValuePair "${n}.path"    (pathToUnit    n v)) cfg.paths
        // mapAttrs' (n: v: nameValuePair "${n}.service" (serviceToUnit n v)) cfg.services
        // mapAttrs' (n: v: nameValuePair "${n}.slice"   (sliceToUnit   n v)) cfg.slices
        // mapAttrs' (n: v: nameValuePair "${n}.socket"  (socketToUnit  n v)) cfg.sockets
        // mapAttrs' (n: v: nameValuePair "${n}.target"  (targetToUnit  n v)) cfg.targets
        // mapAttrs' (n: v: nameValuePair "${n}.timer"   (timerToUnit   n v)) cfg.timers
        // listToAttrs (map
                     (v: let n = escapeSystemdPath v.where;
                         in nameValuePair "${n}.mount" (mountToUnit n v)) cfg.mounts)
        // listToAttrs (map
                     (v: let n = escapeSystemdPath v.where;
                         in nameValuePair "${n}.automount" (automountToUnit n v)) cfg.automounts);

      # The unit in /run/systemd/generator shadows the unit in
      # /etc/systemd/system, but will still apply drop-ins from
      # /etc/systemd/system/foo.service.d/
      #
      # We need IgnoreOnIsolate, otherwise the Requires dependency of
      # a mount unit on its makefs unit causes it to be unmounted when
      # we isolate for switch-root. Use a dummy package so that
      # generateUnits will generate drop-ins instead of unit files.
      packages = [(pkgs.runCommand "dummy" {} ''
        mkdir -p $out/etc/systemd/system
        touch $out/etc/systemd/system/systemd-{makefs,growfs}@.service
      '')];
      services."systemd-makefs@".unitConfig.IgnoreOnIsolate = true;
      services."systemd-growfs@".unitConfig.IgnoreOnIsolate = true;
    };
  };
}
