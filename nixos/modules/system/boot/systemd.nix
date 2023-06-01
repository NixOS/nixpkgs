{ config, lib, pkgs, utils, ... }:

with utils;
with systemdUtils.unitOptions;
with lib;

let

  cfg = config.systemd;

  inherit (systemdUtils.lib)
    generateUnits
    targetToUnit
    serviceToUnit
    socketToUnit
    timerToUnit
    pathToUnit
    mountToUnit
    automountToUnit
    sliceToUnit;

  upstreamSystemUnits =
    [ # Targets.
      "basic.target"
      "sysinit.target"
      "sockets.target"
      "exit.target"
      "graphical.target"
      "multi-user.target"
      "network.target"
      "network-pre.target"
      "network-online.target"
      "nss-lookup.target"
      "nss-user-lookup.target"
      "time-sync.target"
    ] ++ optionals cfg.package.withCryptsetup [
      "cryptsetup.target"
      "cryptsetup-pre.target"
      "remote-cryptsetup.target"
    ] ++ [
      "sigpwr.target"
      "timers.target"
      "paths.target"
      "rpcbind.target"

      # Rescue mode.
      "rescue.target"
      "rescue.service"

      # Udev.
      "systemd-udevd-control.socket"
      "systemd-udevd-kernel.socket"
      "systemd-udevd.service"
      "systemd-udev-settle.service"
      ] ++ (optional (!config.boot.isContainer) "systemd-udev-trigger.service") ++ [
      # hwdb.bin is managed by NixOS
      # "systemd-hwdb-update.service"

      # Consoles.
      "getty.target"
      "getty-pre.target"
      "getty@.service"
      "serial-getty@.service"
      "console-getty.service"
      "container-getty@.service"
      "systemd-vconsole-setup.service"

      # Hardware (started by udev when a relevant device is plugged in).
      "sound.target"
      "bluetooth.target"
      "printer.target"
      "smartcard.target"

      # Kernel module loading.
      "systemd-modules-load.service"
      "kmod-static-nodes.service"
      "modprobe@.service"

      # Filesystems.
      "systemd-fsck@.service"
      "systemd-fsck-root.service"
      "systemd-growfs@.service"
      "systemd-growfs-root.service"
      "systemd-remount-fs.service"
      "systemd-pstore.service"
      "local-fs.target"
      "local-fs-pre.target"
      "remote-fs.target"
      "remote-fs-pre.target"
      "swap.target"
      "dev-hugepages.mount"
      "dev-mqueue.mount"
      "sys-fs-fuse-connections.mount"
      ] ++ (optional (!config.boot.isContainer) "sys-kernel-config.mount") ++ [
      "sys-kernel-debug.mount"

      # Maintaining state across reboots.
      "systemd-random-seed.service"
      "systemd-backlight@.service"
      "systemd-rfkill.service"
      "systemd-rfkill.socket"

      # Hibernate / suspend.
      "hibernate.target"
      "suspend.target"
      "suspend-then-hibernate.target"
      "sleep.target"
      "hybrid-sleep.target"
      "systemd-hibernate.service"
      "systemd-hybrid-sleep.service"
      "systemd-suspend.service"
      "systemd-suspend-then-hibernate.service"

      # Reboot stuff.
      "reboot.target"
      "systemd-reboot.service"
      "poweroff.target"
      "systemd-poweroff.service"
      "halt.target"
      "systemd-halt.service"
      "shutdown.target"
      "umount.target"
      "final.target"
      "kexec.target"
      "systemd-kexec.service"
    ] ++ lib.optional cfg.package.withUtmp "systemd-update-utmp.service" ++ [

      # Password entry.
      "systemd-ask-password-console.path"
      "systemd-ask-password-console.service"
      "systemd-ask-password-wall.path"
      "systemd-ask-password-wall.service"

      # Slices / containers.
      "slices.target"
    ] ++ optionals cfg.package.withImportd [
      "systemd-importd.service"
    ] ++ optionals cfg.package.withMachined [
      "machine.slice"
      "machines.target"
      "systemd-machined.service"
    ] ++ [
      "systemd-nspawn@.service"

      # Misc.
      "systemd-sysctl.service"
    ] ++ optionals cfg.package.withTimedated [
      "dbus-org.freedesktop.timedate1.service"
      "systemd-timedated.service"
    ] ++ optionals cfg.package.withLocaled [
      "dbus-org.freedesktop.locale1.service"
      "systemd-localed.service"
    ] ++ optionals cfg.package.withHostnamed [
      "dbus-org.freedesktop.hostname1.service"
      "systemd-hostnamed.service"
    ] ++ optionals cfg.package.withPortabled [
      "dbus-org.freedesktop.portable1.service"
      "systemd-portabled.service"
    ] ++ [
      "systemd-exit.service"
      "systemd-update-done.service"
    ] ++ cfg.additionalUpstreamSystemUnits;

  upstreamSystemWants =
    [ "sysinit.target.wants"
      "sockets.target.wants"
      "local-fs.target.wants"
      "multi-user.target.wants"
      "timers.target.wants"
    ];

  proxy_env = config.networking.proxy.envVars;

in

{
  ###### interface

  options = {

    systemd.package = mkOption {
      default = pkgs.systemd;
      defaultText = literalExpression "pkgs.systemd";
      type = types.package;
      description = lib.mdDoc "The systemd package.";
    };

    systemd.units = mkOption {
      description = lib.mdDoc "Definition of systemd units.";
      default = {};
      type = systemdUtils.types.units;
    };

    systemd.packages = mkOption {
      default = [];
      type = types.listOf types.package;
      example = literalExpression "[ pkgs.systemd-cryptsetup-generator ]";
      description = lib.mdDoc "Packages providing systemd units and hooks.";
    };

    systemd.targets = mkOption {
      default = {};
      type = systemdUtils.types.targets;
      description = lib.mdDoc "Definition of systemd target units.";
    };

    systemd.services = mkOption {
      default = {};
      type = systemdUtils.types.services;
      description = lib.mdDoc "Definition of systemd service units.";
    };

    systemd.sockets = mkOption {
      default = {};
      type = systemdUtils.types.sockets;
      description = lib.mdDoc "Definition of systemd socket units.";
    };

    systemd.timers = mkOption {
      default = {};
      type = systemdUtils.types.timers;
      description = lib.mdDoc "Definition of systemd timer units.";
    };

    systemd.paths = mkOption {
      default = {};
      type = systemdUtils.types.paths;
      description = lib.mdDoc "Definition of systemd path units.";
    };

    systemd.mounts = mkOption {
      default = [];
      type = systemdUtils.types.mounts;
      description = lib.mdDoc ''
        Definition of systemd mount units.
        This is a list instead of an attrSet, because systemd mandates the names to be derived from
        the 'where' attribute.
      '';
    };

    systemd.automounts = mkOption {
      default = [];
      type = systemdUtils.types.automounts;
      description = lib.mdDoc ''
        Definition of systemd automount units.
        This is a list instead of an attrSet, because systemd mandates the names to be derived from
        the 'where' attribute.
      '';
    };

    systemd.slices = mkOption {
      default = {};
      type = systemdUtils.types.slices;
      description = lib.mdDoc "Definition of slice configurations.";
    };

    systemd.generators = mkOption {
      type = types.attrsOf types.path;
      default = {};
      example = { systemd-gpt-auto-generator = "/dev/null"; };
      description = lib.mdDoc ''
        Definition of systemd generators.
        For each `NAME = VALUE` pair of the attrSet, a link is generated from
        `/etc/systemd/system-generators/NAME` to `VALUE`.
      '';
    };

    systemd.shutdown = mkOption {
      type = types.attrsOf types.path;
      default = {};
      description = lib.mdDoc ''
        Definition of systemd shutdown executables.
        For each `NAME = VALUE` pair of the attrSet, a link is generated from
        `/etc/systemd/system-shutdown/NAME` to `VALUE`.
      '';
    };

    systemd.defaultUnit = mkOption {
      default = "multi-user.target";
      type = types.str;
      description = lib.mdDoc "Default unit started when the system boots.";
    };

    systemd.ctrlAltDelUnit = mkOption {
      default = "reboot.target";
      type = types.str;
      example = "poweroff.target";
      description = lib.mdDoc ''
        Target that should be started when Ctrl-Alt-Delete is pressed.
      '';
    };

    systemd.globalEnvironment = mkOption {
      type = with types; attrsOf (nullOr (oneOf [ str path package ]));
      default = {};
      example = { TZ = "CET"; };
      description = lib.mdDoc ''
        Environment variables passed to *all* systemd units.
      '';
    };

    systemd.managerEnvironment = mkOption {
      type = with types; attrsOf (nullOr (oneOf [ str path package ]));
      default = {};
      example = { SYSTEMD_LOG_LEVEL = "debug"; };
      description = lib.mdDoc ''
        Environment variables of PID 1. These variables are
        *not* passed to started units.
      '';
    };

    systemd.enableCgroupAccounting = mkOption {
      default = true;
      type = types.bool;
      description = lib.mdDoc ''
        Whether to enable cgroup accounting.
      '';
    };

    systemd.enableUnifiedCgroupHierarchy = mkOption {
      default = true;
      type = types.bool;
      description = lib.mdDoc ''
        Whether to enable the unified cgroup hierarchy (cgroupsv2).
      '';
    };

    systemd.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "DefaultLimitCORE=infinity";
      description = lib.mdDoc ''
        Extra config options for systemd. See systemd-system.conf(5) man page
        for available options.
      '';
    };

    systemd.sleep.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "HibernateDelaySec=1h";
      description = lib.mdDoc ''
        Extra config options for systemd sleep state logic.
        See sleep.conf.d(5) man page for available options.
      '';
    };

    systemd.additionalUpstreamSystemUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [ "debug-shell.service" "systemd-quotacheck.service" ];
      description = lib.mdDoc ''
        Additional units shipped with systemd that shall be enabled.
      '';
    };

    systemd.suppressedSystemUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [ "systemd-backlight@.service" ];
      description = lib.mdDoc ''
        A list of units to skip when generating system systemd configuration directory. This has
        priority over upstream units, {option}`systemd.units`, and
        {option}`systemd.additionalUpstreamSystemUnits`. The main purpose of this is to
        prevent a upstream systemd unit from being added to the initrd with any modifications made to it
        by other NixOS modules.
      '';
    };

    systemd.watchdog.device = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/dev/watchdog";
      description = lib.mdDoc ''
        The path to a hardware watchdog device which will be managed by systemd.
        If not specified, systemd will default to /dev/watchdog.
      '';
    };

    systemd.watchdog.runtimeTime = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "30s";
      description = lib.mdDoc ''
        The amount of time which can elapse before a watchdog hardware device
        will automatically reboot the system. Valid time units include "ms",
        "s", "min", "h", "d", and "w".
      '';
    };

    systemd.watchdog.rebootTime = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "10m";
      description = lib.mdDoc ''
        The amount of time which can elapse after a reboot has been triggered
        before a watchdog hardware device will automatically reboot the system.
        Valid time units include "ms", "s", "min", "h", "d", and "w".
      '';
    };

    systemd.watchdog.kexecTime = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "10m";
      description = lib.mdDoc ''
        The amount of time which can elapse when kexec is being executed before
        a watchdog hardware device will automatically reboot the system. This
        option should only be enabled if reloadTime is also enabled. Valid
        time units include "ms", "s", "min", "h", "d", and "w".
      '';
    };
  };


  ###### implementation

  config = {

    warnings = concatLists (
      mapAttrsToList
        (name: service:
          let
            type = service.serviceConfig.Type or "";
            restart = service.serviceConfig.Restart or "no";
            hasDeprecated = builtins.hasAttr "StartLimitInterval" service.serviceConfig;
          in
            concatLists [
              (optional (type == "oneshot" && (restart == "always" || restart == "on-success"))
                "Service '${name}.service' with 'Type=oneshot' cannot have 'Restart=always' or 'Restart=on-success'"
              )
              (optional hasDeprecated
                "Service '${name}.service' uses the attribute 'StartLimitInterval' in the Service section, which is deprecated. See https://github.com/NixOS/nixpkgs/issues/45786."
              )
              (optional (service.reloadIfChanged && service.reloadTriggers != [])
                "Service '${name}.service' has both 'reloadIfChanged' and 'reloadTriggers' set. This is probably not what you want, because 'reloadTriggers' behave the same whay as 'restartTriggers' if 'reloadIfChanged' is set."
              )
            ]
        )
        cfg.services
    );

    system.build.units = cfg.units;

    system.nssModules = [ cfg.package.out ];
    system.nssDatabases = {
      hosts = (mkMerge [
        (mkOrder 400 ["mymachines"]) # 400 to ensure it comes before resolve (which is mkBefore'd)
        (mkOrder 999 ["myhostname"]) # after files (which is 998), but before regular nss modules
      ]);
      passwd = (mkMerge [
        (mkAfter [ "systemd" ])
      ]);
      group = (mkMerge [
        (mkAfter [ "[success=merge] systemd" ]) # need merge so that NSS won't stop at file-based groups
      ]);
    };

    environment.systemPackages = [ cfg.package ];

    environment.etc = let
      # generate contents for /etc/systemd/system-${type} from attrset of links and packages
      hooks = type: links: pkgs.runCommand "system-${type}" {
          preferLocalBuild = true;
          packages = cfg.packages;
      } ''
        set -e
        mkdir -p $out
        for package in $packages
        do
          for hook in $package/lib/systemd/system-${type}/*
          do
            ln -s $hook $out/
          done
        done
        ${concatStrings (mapAttrsToList (exec: target: "ln -s ${target} $out/${exec};\n") links)}
      '';

      enabledUpstreamSystemUnits = filter (n: ! elem n cfg.suppressedSystemUnits) upstreamSystemUnits;
      enabledUnits = filterAttrs (n: v: ! elem n cfg.suppressedSystemUnits) cfg.units;

    in ({
      "systemd/system".source = generateUnits {
        type = "system";
        units = enabledUnits;
        upstreamUnits = enabledUpstreamSystemUnits;
        upstreamWants = upstreamSystemWants;
      };

      "systemd/system.conf".text = ''
        [Manager]
        ManagerEnvironment=${lib.concatStringsSep " " (lib.mapAttrsToList (n: v: "${n}=${lib.escapeShellArg v}") cfg.managerEnvironment)}
        ${optionalString config.systemd.enableCgroupAccounting ''
          DefaultCPUAccounting=yes
          DefaultIOAccounting=yes
          DefaultBlockIOAccounting=yes
          DefaultIPAccounting=yes
        ''}
        DefaultLimitCORE=infinity
        ${optionalString (config.systemd.watchdog.device != null) ''
          WatchdogDevice=${config.systemd.watchdog.device}
        ''}
        ${optionalString (config.systemd.watchdog.runtimeTime != null) ''
          RuntimeWatchdogSec=${config.systemd.watchdog.runtimeTime}
        ''}
        ${optionalString (config.systemd.watchdog.rebootTime != null) ''
          RebootWatchdogSec=${config.systemd.watchdog.rebootTime}
        ''}
        ${optionalString (config.systemd.watchdog.kexecTime != null) ''
          KExecWatchdogSec=${config.systemd.watchdog.kexecTime}
        ''}

        ${config.systemd.extraConfig}
      '';

      "systemd/sleep.conf".text = ''
        [Sleep]
        ${config.systemd.sleep.extraConfig}
      '';

      "systemd/system-generators" = { source = hooks "generators" cfg.generators; };
      "systemd/system-shutdown" = { source = hooks "shutdown" cfg.shutdown; };
    });

    services.dbus.enable = true;

    users.users.systemd-network = {
      uid = config.ids.uids.systemd-network;
      group = "systemd-network";
    };
    users.groups.systemd-network.gid = config.ids.gids.systemd-network;
    users.users.systemd-resolve = {
      uid = config.ids.uids.systemd-resolve;
      group = "systemd-resolve";
    };
    users.groups.systemd-resolve.gid = config.ids.gids.systemd-resolve;

    # Target for ‘charon send-keys’ to hook into.
    users.groups.keys.gid = config.ids.gids.keys;

    systemd.targets.keys =
      { description = "Security Keys";
        unitConfig.X-StopOnReconfiguration = true;
      };

    systemd.units =
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

      # Environment of PID 1
      systemd.managerEnvironment = {
        # Doesn't contain systemd itself - everything works so it seems to use the compiled-in value for its tools
        # util-linux is needed for the main fsck utility wrapping the fs-specific ones
        PATH = lib.makeBinPath (config.system.fsPackages ++ [cfg.package.util-linux]);
        LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
        TZDIR = "/etc/zoneinfo";
        # If SYSTEMD_UNIT_PATH ends with an empty component (":"), the usual unit load path will be appended to the contents of the variable
        SYSTEMD_UNIT_PATH = lib.mkIf (config.boot.extraSystemdUnitPaths != []) "${builtins.concatStringsSep ":" config.boot.extraSystemdUnitPaths}:";
      };


    system.requiredKernelConfig = map config.lib.kernelConfig.isEnabled
      [ "DEVTMPFS" "CGROUPS" "INOTIFY_USER" "SIGNALFD" "TIMERFD" "EPOLL" "NET"
        "SYSFS" "PROC_FS" "FHANDLE" "CRYPTO_USER_API_HASH" "CRYPTO_HMAC"
        "CRYPTO_SHA256" "DMIID" "AUTOFS4_FS" "TMPFS_POSIX_ACL"
        "TMPFS_XATTR" "SECCOMP"
      ];

    # Generate timer units for all services that have a ‘startAt’ value.
    systemd.timers =
      mapAttrs (name: service:
        { wantedBy = [ "timers.target" ];
          timerConfig.OnCalendar = service.startAt;
        })
        (filterAttrs (name: service: service.enable && service.startAt != []) cfg.services);

    # Some overrides to upstream units.
    systemd.services."systemd-backlight@".restartIfChanged = false;
    systemd.services."systemd-fsck@".restartIfChanged = false;
    systemd.services."systemd-fsck@".path = [ config.system.path ];
    systemd.services.systemd-random-seed.restartIfChanged = false;
    systemd.services.systemd-remount-fs.restartIfChanged = false;
    systemd.services.systemd-update-utmp.restartIfChanged = false;
    systemd.services.systemd-udev-settle.restartIfChanged = false; # Causes long delays in nixos-rebuild
    systemd.targets.local-fs.unitConfig.X-StopOnReconfiguration = true;
    systemd.targets.remote-fs.unitConfig.X-StopOnReconfiguration = true;
    systemd.targets.network-online.wantedBy = [ "multi-user.target" ];
    systemd.services.systemd-importd.environment = proxy_env;
    systemd.services.systemd-pstore.wantedBy = [ "sysinit.target" ]; # see #81138

    # NixOS has kernel modules in a different location, so override that here.
    systemd.services.kmod-static-nodes.unitConfig.ConditionFileNotEmpty = [
      ""  # required to unset the previous value!
      "/run/booted-system/kernel-modules/lib/modules/%v/modules.devname"
    ];

    # Don't bother with certain units in containers.
    systemd.services.systemd-remount-fs.unitConfig.ConditionVirtualization = "!container";
    systemd.services.systemd-random-seed.unitConfig.ConditionVirtualization = "!container";

    # Increase numeric PID range (set directly instead of copying a one-line file from systemd)
    # https://github.com/systemd/systemd/pull/12226
    boot.kernel.sysctl."kernel.pid_max" = mkIf pkgs.stdenv.is64bit (lib.mkDefault 4194304);

    boot.kernelParams = optional (!cfg.enableUnifiedCgroupHierarchy) "systemd.unified_cgroup_hierarchy=0";

    # Avoid potentially degraded system state due to
    # "Userspace Out-Of-Memory (OOM) Killer was skipped because of a failed condition check (ConditionControlGroupController=v2)."
    systemd.oomd.enable = mkIf (!cfg.enableUnifiedCgroupHierarchy) false;

    services.logrotate.settings = {
      "/var/log/btmp" = mapAttrs (_: mkDefault) {
        frequency = "monthly";
        rotate = 1;
        create = "0660 root ${config.users.groups.utmp.name}";
        minsize = "1M";
      };
      "/var/log/wtmp" = mapAttrs (_: mkDefault) {
        frequency = "monthly";
        rotate = 1;
        create = "0664 root ${config.users.groups.utmp.name}";
        minsize = "1M";
      };
    };
  };

  # FIXME: Remove these eventually.
  imports =
    [ (mkRenamedOptionModule [ "boot" "systemd" "sockets" ] [ "systemd" "sockets" ])
      (mkRenamedOptionModule [ "boot" "systemd" "targets" ] [ "systemd" "targets" ])
      (mkRenamedOptionModule [ "boot" "systemd" "services" ] [ "systemd" "services" ])
      (mkRenamedOptionModule [ "jobs" ] [ "systemd" "services" ])
      (mkRemovedOptionModule [ "systemd" "generator-packages" ] "Use systemd.packages instead.")
    ];
}
