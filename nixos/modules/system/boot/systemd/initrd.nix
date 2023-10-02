{ lib, options, config, utils, pkgs, ... }:

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
    "systemd-journald-audit.socket"
    "systemd-journald-dev-log.socket"
    "systemd-journald.service"
    "systemd-journald.socket"
    "systemd-kexec.service"
    "systemd-modules-load.service"
    "systemd-poweroff.service"
    "systemd-reboot.service"
    "systemd-sysctl.service"
    "systemd-tmpfiles-setup-dev.service"
    "systemd-tmpfiles-setup.service"
    "timers.target"
    "umount.target"
  ] ++ cfg.additionalUpstreamUnits;

  upstreamWants = [
    "sysinit.target.wants"
  ];

  enabledUpstreamUnits = filter (n: ! elem n cfg.suppressedUnits) upstreamUnits;
  enabledUnits = filterAttrs (n: v: ! elem n cfg.suppressedUnits) cfg.units;
  jobScripts = concatLists (mapAttrsToList (_: unit: unit.jobScripts or []) (filterAttrs (_: v: v.enable) cfg.services));

  stage1Units = generateUnits {
    type = "initrd";
    units = enabledUnits;
    upstreamUnits = enabledUpstreamUnits;
    inherit upstreamWants;
    inherit (cfg) packages package;
  };

  fileSystems = filter utils.fsNeededForBoot config.system.build.fileSystems;

  needMakefs = lib.any (fs: fs.autoFormat) fileSystems;

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
    name = "initrd-bin-env";
    paths = map getBin cfg.initrdBin;
    pathsToLink = ["/bin" "/sbin"];
    postBuild = concatStringsSep "\n" (mapAttrsToList (n: v: "ln -sf '${v}' $out/bin/'${n}'") cfg.extraBin);
  };

  initialRamdisk = pkgs.makeInitrdNG {
    name = "initrd-${kernel-name}";
    inherit (config.boot.initrd) compressor compressorArgs prepend;
    inherit (cfg) strip;

    contents = map (path: { object = path; symlink = ""; }) (subtractLists cfg.suppressedStorePaths cfg.storePaths)
      ++ mapAttrsToList (_: v: { object = v.source; symlink = v.target; }) (filterAttrs (_: v: v.enable) cfg.contents);
  };

in {
  options.boot.initrd.systemd = {
    enable = mkEnableOption (lib.mdDoc "systemd in initrd") // {
      description = lib.mdDoc ''
        Whether to enable systemd in initrd. The unit options such as
        {option}`boot.initrd.systemd.services` are the same as their
        stage 2 counterparts such as {option}`systemd.services`,
        except that `restartTriggers` and `reloadTriggers` are not
        supported.

        Note: This is experimental. Some of the `boot.initrd` options
        are not supported when this is enabled, and the options under
        `boot.initrd.systemd` are subject to change.
      '';
    };

    package = mkPackageOptionMD pkgs "systemd" {
      default = "systemdStage1";
    };

    extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "DefaultLimitCORE=infinity";
      description = lib.mdDoc ''
        Extra config options for systemd. See systemd-system.conf(5) man page
        for available options.
      '';
    };

    managerEnvironment = mkOption {
      type = with types; attrsOf (nullOr (oneOf [ str path package ]));
      default = {};
      example = { SYSTEMD_LOG_LEVEL = "debug"; };
      description = lib.mdDoc ''
        Environment variables of PID 1. These variables are
        *not* passed to started units.
      '';
    };

    contents = mkOption {
      description = lib.mdDoc "Set of files that have to be linked into the initrd";
      example = literalExpression ''
        {
          "/etc/hostname".text = "mymachine";
        }
      '';
      default = {};
      type = utils.systemdUtils.types.initrdContents;
    };

    storePaths = mkOption {
      description = lib.mdDoc ''
        Store paths to copy into the initrd as well.
      '';
      type = with types; listOf (oneOf [ singleLineStr package ]);
      default = [];
    };

    strip = mkOption {
      description = lib.mdDoc ''
        Whether to completely strip executables and libraries copied to the initramfs.

        Setting this to false may save on the order of 30MiB on the
        machine building the system (by avoiding a binutils
        reference), at the cost of ~1MiB of initramfs size. This puts
        this option firmly in the territory of micro-optimisation.
      '';
      type = types.bool;
      default = true;
    };

    extraBin = mkOption {
      description = lib.mdDoc ''
        Tools to add to /bin
      '';
      example = literalExpression ''
        {
          umount = ''${pkgs.util-linux}/bin/umount;
        }
      '';
      type = types.attrsOf types.path;
      default = {};
    };

    suppressedStorePaths = mkOption {
      description = lib.mdDoc ''
        Store paths specified in the storePaths option that
        should not be copied.
      '';
      type = types.listOf types.singleLineStr;
      default = [];
    };

    emergencyAccess = mkOption {
      type = with types; oneOf [ bool (nullOr (passwdEntry str)) ];
      description = lib.mdDoc ''
        Set to true for unauthenticated emergency access, and false for
        no emergency access.

        Can also be set to a hashed super user password to allow
        authenticated access to the emergency mode.
      '';
      default = false;
    };

    initrdBin = mkOption {
      type = types.listOf types.package;
      default = [];
      description = lib.mdDoc ''
        Packages to include in /bin for the stage 1 emergency shell.
      '';
    };

    additionalUpstreamUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [ "debug-shell.service" "systemd-quotacheck.service" ];
      description = lib.mdDoc ''
        Additional units shipped with systemd that shall be enabled.
      '';
    };

    suppressedUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [ "systemd-backlight@.service" ];
      description = lib.mdDoc ''
        A list of units to skip when generating system systemd configuration directory. This has
        priority over upstream units, {option}`boot.initrd.systemd.units`, and
        {option}`boot.initrd.systemd.additionalUpstreamUnits`. The main purpose of this is to
        prevent a upstream systemd unit from being added to the initrd with any modifications made to it
        by other NixOS modules.
      '';
    };

    units = mkOption {
      description = lib.mdDoc "Definition of systemd units.";
      default = {};
      visible = "shallow";
      type = systemdUtils.types.units;
    };

    packages = mkOption {
      default = [];
      type = types.listOf types.package;
      example = literalExpression "[ pkgs.systemd-cryptsetup-generator ]";
      description = lib.mdDoc "Packages providing systemd units and hooks.";
    };

    targets = mkOption {
      default = {};
      visible = "shallow";
      type = systemdUtils.types.initrdTargets;
      description = lib.mdDoc "Definition of systemd target units.";
    };

    services = mkOption {
      default = {};
      type = systemdUtils.types.initrdServices;
      visible = "shallow";
      description = lib.mdDoc "Definition of systemd service units.";
    };

    sockets = mkOption {
      default = {};
      type = systemdUtils.types.initrdSockets;
      visible = "shallow";
      description = lib.mdDoc "Definition of systemd socket units.";
    };

    timers = mkOption {
      default = {};
      type = systemdUtils.types.initrdTimers;
      visible = "shallow";
      description = lib.mdDoc "Definition of systemd timer units.";
    };

    paths = mkOption {
      default = {};
      type = systemdUtils.types.initrdPaths;
      visible = "shallow";
      description = lib.mdDoc "Definition of systemd path units.";
    };

    mounts = mkOption {
      default = [];
      type = systemdUtils.types.initrdMounts;
      visible = "shallow";
      description = lib.mdDoc ''
        Definition of systemd mount units.
        This is a list instead of an attrSet, because systemd mandates the names to be derived from
        the 'where' attribute.
      '';
    };

    automounts = mkOption {
      default = [];
      type = systemdUtils.types.automounts;
      visible = "shallow";
      description = lib.mdDoc ''
        Definition of systemd automount units.
        This is a list instead of an attrSet, because systemd mandates the names to be derived from
        the 'where' attribute.
      '';
    };

    slices = mkOption {
      default = {};
      type = systemdUtils.types.slices;
      visible = "shallow";
      description = lib.mdDoc "Definition of slice configurations.";
    };

    enableTpm2 = mkOption {
      default = true;
      type = types.bool;
      description = lib.mdDoc ''
        Whether to enable TPM2 support in the initrd.
      '';
    };
  };

  config = mkIf (config.boot.initrd.enable && cfg.enable) {
    system.build = { inherit initialRamdisk; };

    boot.initrd.availableKernelModules = [
      # systemd needs this for some features
      "autofs4"
      # systemd-cryptenroll
    ] ++ lib.optional cfg.enableTpm2 "tpm-tis"
    ++ lib.optional (cfg.enableTpm2 && !(pkgs.stdenv.hostPlatform.isRiscV64 || pkgs.stdenv.hostPlatform.isArmv7)) "tpm-crb";

    boot.initrd.systemd = {
      initrdBin = [pkgs.bash pkgs.coreutils cfg.package.kmod cfg.package] ++ config.system.fsPackages;
      extraBin = {
        less = "${pkgs.less}/bin/less";
        mount = "${cfg.package.util-linux}/bin/mount";
        umount = "${cfg.package.util-linux}/bin/umount";
        fsck = "${cfg.package.util-linux}/bin/fsck";
      };

      managerEnvironment.PATH = "/bin:/sbin";

      contents = {
        "/tmp/.keep".text = "systemd requires the /tmp mount point in the initrd cpio archive";
        "/init".source = "${cfg.package}/lib/systemd/systemd";
        "/etc/systemd/system".source = stage1Units;

        "/etc/systemd/system.conf".text = ''
          [Manager]
          DefaultEnvironment=PATH=/bin:/sbin
          ${cfg.extraConfig}
          ManagerEnvironment=${lib.concatStringsSep " " (lib.mapAttrsToList (n: v: "${n}=${lib.escapeShellArg v}") cfg.managerEnvironment)}
        '';

        "/lib/modules".source = "${modulesClosure}/lib/modules";
        "/lib/firmware".source = "${modulesClosure}/lib/firmware";

        "/etc/modules-load.d/nixos.conf".text = concatStringsSep "\n" config.boot.initrd.kernelModules;

        # We can use either ! or * to lock the root account in the
        # console, but some software like OpenSSH won't even allow you
        # to log in with an SSH key if you use ! so we use * instead
        "/etc/shadow".text = "root:${if isBool cfg.emergencyAccess then optionalString (!cfg.emergencyAccess) "*" else cfg.emergencyAccess}:::::::";

        "/bin".source = "${initrdBinEnv}/bin";
        "/sbin".source = "${initrdBinEnv}/sbin";

        "/etc/sysctl.d/nixos.conf".text = "kernel.modprobe = /sbin/modprobe";
        "/etc/modprobe.d/systemd.conf".source = "${cfg.package}/lib/modprobe.d/systemd.conf";
        "/etc/modprobe.d/ubuntu.conf".source = pkgs.runCommand "initrd-kmod-blacklist-ubuntu" { } ''
          ${pkgs.buildPackages.perl}/bin/perl -0pe 's/## file: iwlwifi.conf(.+?)##/##/s;' $src > $out
        '';
        "/etc/modprobe.d/debian.conf".source = pkgs.kmod-debian-aliases;

        "/etc/os-release".source = config.boot.initrd.osRelease;
        "/etc/initrd-release".source = config.boot.initrd.osRelease;

      } // optionalAttrs (config.environment.etc ? "modprobe.d/nixos.conf") {
        "/etc/modprobe.d/nixos.conf".source = config.environment.etc."modprobe.d/nixos.conf".source;
      };

      storePaths = [
        # systemd tooling
        "${cfg.package}/lib/systemd/systemd-fsck"
        "${cfg.package}/lib/systemd/systemd-hibernate-resume"
        "${cfg.package}/lib/systemd/systemd-journald"
        (lib.mkIf needMakefs "${cfg.package}/lib/systemd/systemd-makefs")
        "${cfg.package}/lib/systemd/systemd-modules-load"
        "${cfg.package}/lib/systemd/systemd-remount-fs"
        "${cfg.package}/lib/systemd/systemd-shutdown"
        "${cfg.package}/lib/systemd/systemd-sulogin-shell"
        "${cfg.package}/lib/systemd/systemd-sysctl"

        # generators
        "${cfg.package}/lib/systemd/system-generators/systemd-debug-generator"
        "${cfg.package}/lib/systemd/system-generators/systemd-fstab-generator"
        "${cfg.package}/lib/systemd/system-generators/systemd-gpt-auto-generator"
        "${cfg.package}/lib/systemd/system-generators/systemd-hibernate-resume-generator"
        "${cfg.package}/lib/systemd/system-generators/systemd-run-generator"

        # utilities needed by systemd
        "${cfg.package.util-linux}/bin/mount"
        "${cfg.package.util-linux}/bin/umount"
        "${cfg.package.util-linux}/bin/sulogin"

        # so NSS can look up usernames
        "${pkgs.glibc}/lib/libnss_files.so.2"
      ] ++ optionals (cfg.package.withCryptsetup && cfg.enableTpm2) [
        # tpm2 support
        "${cfg.package}/lib/cryptsetup/libcryptsetup-token-systemd-tpm2.so"
        pkgs.tpm2-tss
      ] ++ optionals cfg.package.withCryptsetup [
        # fido2 support
        "${cfg.package}/lib/cryptsetup/libcryptsetup-token-systemd-fido2.so"
        "${pkgs.libfido2}/lib/libfido2.so.1"
      ] ++ jobScripts;

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

      # make sure all the /dev nodes are set up
      services.systemd-tmpfiles-setup-dev.wantedBy = ["sysinit.target"];

      services.initrd-nixos-activation = {
        after = [ "initrd-fs.target" ];
        requiredBy = [ "initrd.target" ];
        unitConfig.AssertPathExists = "/etc/initrd-release";
        serviceConfig.Type = "oneshot";
        description = "NixOS Activation";

        script = /* bash */ ''
          set -uo pipefail
          export PATH="/bin:${cfg.package.util-linux}/bin"

          # Figure out what closure to boot
          closure=
          for o in $(< /proc/cmdline); do
              case $o in
                  init=*)
                      IFS== read -r -a initParam <<< "$o"
                      closure="$(dirname "''${initParam[1]}")"
                      ;;
              esac
          done

          # Sanity check
          if [ -z "''${closure:-}" ]; then
            echo 'No init= parameter on the kernel command line' >&2
            exit 1
          fi

          # If we are not booting a NixOS closure (e.g. init=/bin/sh),
          # we don't know what root to prepare so we don't do anything
          if ! [ -x "/sysroot$(readlink "/sysroot$closure/prepare-root" || echo "$closure/prepare-root")" ]; then
            echo "NEW_INIT=''${initParam[1]}" > /etc/switch-root.conf
            echo "$closure does not look like a NixOS installation - not activating"
            exit 0
          fi
          echo 'NEW_INIT=' > /etc/switch-root.conf


          # We need to propagate /run for things like /run/booted-system
          # and /run/current-system.
          mkdir -p /sysroot/run
          mount --bind /run /sysroot/run

          # Initialize the system
          export IN_NIXOS_SYSTEMD_STAGE1=true
          exec chroot /sysroot $closure/prepare-root
        '';
      };

      # This will either call systemctl with the new init as the last parameter (which
      # is the case when not booting a NixOS system) or with an empty string, causing
      # systemd to bypass its verification code that checks whether the next file is a systemd
      # and using its compiled-in value
      services.initrd-switch-root.serviceConfig = {
        EnvironmentFile = "-/etc/switch-root.conf";
        ExecStart = [
          ""
          ''systemctl --no-block switch-root /sysroot "''${NEW_INIT}"''
        ];
      };

      services.panic-on-fail = {
        wantedBy = ["emergency.target"];
        unitConfig = {
          DefaultDependencies = false;
          ConditionKernelCommandLine = [
            "|boot.panic_on_fail"
            "|stage1panic"
          ];
        };
        script = ''
          echo c > /proc/sysrq-trigger
        '';
        serviceConfig.Type = "oneshot";
      };
    };

    boot.kernelParams = lib.mkIf (config.boot.resumeDevice != "") [ "resume=${config.boot.resumeDevice}" ];
  };
}
