{ config, lib, pkgs, utils, ... }:

let
  inherit (utils) systemdUtils;

  cfg = config.systemd;

  inherit (utils.systemdUtils.lib)
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
      "first-boot-complete.target"
    ] ++ lib.optionals cfg.package.withCryptsetup [
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

      # systemd-debug-generator
      "debug-shell.service"

      # Udev.
      "systemd-udevd-control.socket"
      "systemd-udevd-kernel.socket"
      "systemd-udevd.service"
      "systemd-udev-settle.service"
      ] ++ (lib.optional (!config.boot.isContainer) "systemd-udev-trigger.service") ++ [
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
      ] ++ (lib.optional (!config.boot.isContainer) "sys-kernel-config.mount") ++ [
      "sys-kernel-debug.mount"

      # Maintaining state across reboots.
      "systemd-random-seed.service"
      ] ++ (lib.optional cfg.package.withBootloader "systemd-boot-random-seed.service") ++ [
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
      "systemd-hibernate-clear.service"
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

      # Varlink APIs
      "systemd-bootctl@.service"
      "systemd-bootctl.socket"
      "systemd-creds@.service"
      "systemd-creds.socket"
    ] ++ lib.optional cfg.package.withTpm2Tss [
      "systemd-pcrlock@.service"
      "systemd-pcrlock.socket"
    ] ++ [

      # Slices / containers.
      "slices.target"
    ] ++ lib.optionals cfg.package.withImportd [
      "systemd-importd.service"
    ] ++ lib.optionals cfg.package.withMachined [
      "machine.slice"
      "machines.target"
      "systemd-machined.service"
    ] ++ [
      "systemd-nspawn@.service"

      # Misc.
      "systemd-sysctl.service"
      "systemd-machine-id-commit.service"
    ] ++ lib.optionals cfg.package.withTimedated [
      "dbus-org.freedesktop.timedate1.service"
      "systemd-timedated.service"
    ] ++ lib.optionals cfg.package.withLocaled [
      "dbus-org.freedesktop.locale1.service"
      "systemd-localed.service"
    ] ++ lib.optionals cfg.package.withHostnamed [
      "dbus-org.freedesktop.hostname1.service"
      "systemd-hostnamed.service"
      "systemd-hostnamed.socket"
    ] ++ lib.optionals cfg.package.withPortabled [
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

  options.systemd = {

    package = lib.mkPackageOption pkgs "systemd" {};

    enableStrictShellChecks = lib.mkEnableOption "" // { description = "Whether to run shellcheck on the generated scripts for systemd units."; };

    units = lib.mkOption {
      description = "Definition of systemd units; see {manpage}`systemd.unit(5)`.";
      default = {};
      type = systemdUtils.types.units;
    };

    packages = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.package;
      example = lib.literalExpression "[ pkgs.systemd-cryptsetup-generator ]";
      description = "Packages providing systemd units and hooks.";
    };

    targets = lib.mkOption {
      default = {};
      type = systemdUtils.types.targets;
      description = "Definition of systemd target units; see {manpage}`systemd.target(5)`";
    };

    services = lib.mkOption {
      default = {};
      type = systemdUtils.types.services;
      description = "Definition of systemd service units; see {manpage}`systemd.service(5)`.";
    };

    sockets = lib.mkOption {
      default = {};
      type = systemdUtils.types.sockets;
      description = "Definition of systemd socket units; see {manpage}`systemd.socket(5)`.";
    };

    timers = lib.mkOption {
      default = {};
      type = systemdUtils.types.timers;
      description = "Definition of systemd timer units; see {manpage}`systemd.timer(5)`.";
    };

    paths = lib.mkOption {
      default = {};
      type = systemdUtils.types.paths;
      description = "Definition of systemd path units; see {manpage}`systemd.path(5)`.";
    };

    mounts = lib.mkOption {
      default = [];
      type = systemdUtils.types.mounts;
      description = ''
        Definition of systemd mount units; see {manpage}`systemd.mount(5)`.

        This is a list instead of an attrSet, because systemd mandates
        the names to be derived from the `where` attribute.
      '';
    };

    automounts = lib.mkOption {
      default = [];
      type = systemdUtils.types.automounts;
      description = ''
        Definition of systemd automount units; see {manpage}`systemd.automount(5)`.

        This is a list instead of an attrSet, because systemd mandates
        the names to be derived from the `where` attribute.
      '';
    };

    slices = lib.mkOption {
      default = {};
      type = systemdUtils.types.slices;
      description = "Definition of slice configurations; see {manpage}`systemd.slice(5)`.";
    };

    generators = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = {};
      example = { systemd-gpt-auto-generator = "/dev/null"; };
      description = ''
        Definition of systemd generators; see {manpage}`systemd.generator(5)`.

        For each `NAME = VALUE` pair of the attrSet, a link is generated from
        `/etc/systemd/system-generators/NAME` to `VALUE`.
      '';
    };

    shutdown = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = {};
      description = ''
        Definition of systemd shutdown executables.
        For each `NAME = VALUE` pair of the attrSet, a link is generated from
        `/etc/systemd/system-shutdown/NAME` to `VALUE`.
      '';
    };

    defaultUnit = lib.mkOption {
      default = "multi-user.target";
      type = lib.types.str;
      description = ''
        Default unit started when the system boots; see {manpage}`systemd.special(7)`.
      '';
    };

    ctrlAltDelUnit = lib.mkOption {
      default = "reboot.target";
      type = lib.types.str;
      example = "poweroff.target";
      description = ''
        Target that should be started when Ctrl-Alt-Delete is pressed;
        see {manpage}`systemd.special(7)`.
      '';
    };

    globalEnvironment = lib.mkOption {
      type = with lib.types; attrsOf (nullOr (oneOf [ str path package ]));
      default = {};
      example = { TZ = "CET"; };
      description = ''
        Environment variables passed to *all* systemd units.
      '';
    };

    managerEnvironment = lib.mkOption {
      type = with lib.types; attrsOf (nullOr (oneOf [ str path package ]));
      default = {};
      example = { SYSTEMD_LOG_LEVEL = "debug"; };
      description = ''
        Environment variables of PID 1. These variables are
        *not* passed to started units.
      '';
    };

    enableCgroupAccounting = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Whether to enable cgroup accounting; see {manpage}`cgroups(7)`.
      '';
    };

    extraConfig = lib.mkOption {
      default = "";
      type = lib.types.lines;
      example = "DefaultLimitCORE=infinity";
      description = ''
        Extra config options for systemd. See {manpage}`systemd-system.conf(5)` man page
        for available options.
      '';
    };

    sleep.extraConfig = lib.mkOption {
      default = "";
      type = lib.types.lines;
      example = "HibernateDelaySec=1h";
      description = ''
        Extra config options for systemd sleep state logic.
        See {manpage}`sleep.conf.d(5)` man page for available options.
      '';
    };

    additionalUpstreamSystemUnits = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.str;
      example = [ "debug-shell.service" "systemd-quotacheck.service" ];
      description = ''
        Additional units shipped with systemd that shall be enabled.
      '';
    };

    suppressedSystemUnits = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.str;
      example = [ "systemd-backlight@.service" ];
      description = ''
        A list of units to skip when generating system systemd configuration directory. This has
        priority over upstream units, {option}`systemd.units`, and
        {option}`systemd.additionalUpstreamSystemUnits`. The main purpose of this is to
        prevent a upstream systemd unit from being added to the initrd with any modifications made to it
        by other NixOS modules.
      '';
    };

    watchdog.device = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/dev/watchdog";
      description = ''
        The path to a hardware watchdog device which will be managed by systemd.
        If not specified, systemd will default to `/dev/watchdog`.
      '';
    };

    watchdog.runtimeTime = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "30s";
      description = ''
        The amount of time which can elapse before a watchdog hardware device
        will automatically reboot the system.

        Valid time units include "ms", "s", "min", "h", "d", and "w";
        see {manpage}`systemd.time(7)`.
      '';
    };

    watchdog.rebootTime = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "10m";
      description = ''
        The amount of time which can elapse after a reboot has been triggered
        before a watchdog hardware device will automatically reboot the system.
        If left `null`, systemd will use its default of 10 minutes;
        see {manpage}`systemd-system.conf(5)`.

        Valid time units include "ms", "s", "min", "h", "d", and "w";
        see also {manpage}`systemd.time(7)`.
      '';
    };

    watchdog.kexecTime = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "10m";
      description = ''
        The amount of time which can elapse when `kexec` is being executed before
        a watchdog hardware device will automatically reboot the system. This
        option should only be enabled if `reloadTime` is also enabled;
        see {manpage}`kexec(8)`.

        Valid time units include "ms", "s", "min", "h", "d", and "w";
        see also {manpage}`systemd.time(7)`.
      '';
    };
  };


  ###### implementation

  config = {

    warnings = let
      mkOneNetOnlineWarn = typeStr: name: def: lib.optional
        (lib.elem "network-online.target" def.after && !(lib.elem "network-online.target" (def.wants ++ def.requires ++ def.bindsTo)))
        "${name}.${typeStr} is ordered after 'network-online.target' but doesn't depend on it";
      mkNetOnlineWarns = typeStr: defs: lib.concatLists (lib.mapAttrsToList (mkOneNetOnlineWarn typeStr) defs);
      mkMountNetOnlineWarns = typeStr: defs: lib.concatLists (map (m: mkOneNetOnlineWarn typeStr m.what m) defs);
    in lib.concatLists (
      lib.mapAttrsToList
        (name: service:
          let
            type = service.serviceConfig.Type or "";
            restart = service.serviceConfig.Restart or "no";
            hasDeprecated = builtins.hasAttr "StartLimitInterval" service.serviceConfig;
          in
            lib.concatLists [
              (lib.optional (type == "oneshot" && (restart == "always" || restart == "on-success"))
                "Service '${name}.service' with 'Type=oneshot' cannot have 'Restart=always' or 'Restart=on-success'"
              )
              (lib.optional hasDeprecated
                "Service '${name}.service' uses the attribute 'StartLimitInterval' in the Service section, which is deprecated. See https://github.com/NixOS/nixpkgs/issues/45786."
              )
              (lib.optional (service.reloadIfChanged && service.reloadTriggers != [])
                "Service '${name}.service' has both 'reloadIfChanged' and 'reloadTriggers' set. This is probably not what you want, because 'reloadTriggers' behave the same whay as 'restartTriggers' if 'reloadIfChanged' is set."
              )
            ]
        )
        cfg.services
    )
    ++ (mkNetOnlineWarns "target" cfg.targets)
    ++ (mkNetOnlineWarns "service" cfg.services)
    ++ (mkNetOnlineWarns "socket" cfg.sockets)
    ++ (mkNetOnlineWarns "timer" cfg.timers)
    ++ (mkNetOnlineWarns "path" cfg.paths)
    ++ (mkMountNetOnlineWarns "mount" cfg.mounts)
    ++ (mkMountNetOnlineWarns "automount" cfg.automounts)
    ++ (mkNetOnlineWarns "slice" cfg.slices);

    assertions = lib.concatLists (
      lib.mapAttrsToList
        (name: service:
          map (message: {
            assertion = false;
            inherit message;
          }) (lib.concatLists [
            (lib.optional ((builtins.elem "network-interfaces.target" service.after) || (builtins.elem "network-interfaces.target" service.wants))
              "Service '${name}.service' is using the deprecated target network-interfaces.target, which no longer exists. Using network.target is recommended instead."
            )
          ])
        )
        cfg.services
    );

    system.build.units = cfg.units;

    system.nssModules = [ cfg.package.out ];
    system.nssDatabases = {
      hosts = (lib.mkMerge [
        (lib.mkOrder 400 ["mymachines"]) # 400 to ensure it comes before resolve (which is 501)
        (lib.mkOrder 999 ["myhostname"]) # after files (which is 998), but before regular nss modules
      ]);
      passwd = (lib.mkMerge [
        (lib.mkAfter [ "systemd" ])
      ]);
      group = (lib.mkMerge [
        (lib.mkAfter [ "[success=merge] systemd" ]) # need merge so that NSS won't stop at file-based groups
      ]);
    };

    environment.systemPackages = [ cfg.package ];

    environment.etc = let
      # generate contents for /etc/systemd/${dir} from attrset of links and packages
      hooks = dir: links: pkgs.runCommand "${dir}" {
          preferLocalBuild = true;
          packages = cfg.packages;
      } ''
        set -e
        mkdir -p $out
        for package in $packages
        do
          for hook in $package/lib/systemd/${dir}/*
          do
            ln -s $hook $out/
          done
        done
        ${lib.concatStrings (lib.mapAttrsToList (exec: target: "ln -s ${target} $out/${exec};\n") links)}
      '';

      enabledUpstreamSystemUnits = lib.filter (n: ! lib.elem n cfg.suppressedSystemUnits) upstreamSystemUnits;
      enabledUnits = lib.filterAttrs (n: v: ! lib.elem n cfg.suppressedSystemUnits) cfg.units;

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
        ${lib.optionalString cfg.enableCgroupAccounting ''
          DefaultCPUAccounting=yes
          DefaultIOAccounting=yes
          DefaultBlockIOAccounting=yes
          DefaultIPAccounting=yes
        ''}
        DefaultLimitCORE=infinity
        ${lib.optionalString (cfg.watchdog.device != null) ''
          WatchdogDevice=${cfg.watchdog.device}
        ''}
        ${lib.optionalString (cfg.watchdog.runtimeTime != null) ''
          RuntimeWatchdogSec=${cfg.watchdog.runtimeTime}
        ''}
        ${lib.optionalString (cfg.watchdog.rebootTime != null) ''
          RebootWatchdogSec=${cfg.watchdog.rebootTime}
        ''}
        ${lib.optionalString (cfg.watchdog.kexecTime != null) ''
          KExecWatchdogSec=${cfg.watchdog.kexecTime}
        ''}

        ${cfg.extraConfig}
      '';

      "systemd/sleep.conf".text = ''
        [Sleep]
        ${cfg.sleep.extraConfig}
      '';

      "systemd/user-generators" = { source = hooks "user-generators" cfg.user.generators; };
      "systemd/system-generators" = { source = hooks "system-generators" cfg.generators; };
      "systemd/system-shutdown" = { source = hooks "system-shutdown" cfg.shutdown; };

      # Ignore all other preset files so systemd doesn't try to enable/disable
      # units during runtime.
      "systemd/system-preset/00-nixos.preset".text = ''
        ignore *
      '';
      "systemd/user-preset/00-nixos.preset".text = ''
        ignore *
      '';
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

    # This target only exists so that services ordered before sysinit.target
    # are restarted in the correct order, notably BEFORE the other services,
    # when switching configurations.
    systemd.targets.sysinit-reactivation = {
      description = "Reactivate sysinit units";
    };

    systemd.units =
      let
        withName = cfgToUnit: cfg: lib.nameValuePair cfg.name (cfgToUnit cfg);
      in
         lib.mapAttrs' (_: withName pathToUnit) cfg.paths
      // lib.mapAttrs' (_: withName serviceToUnit) cfg.services
      // lib.mapAttrs' (_: withName sliceToUnit) cfg.slices
      // lib.mapAttrs' (_: withName socketToUnit) cfg.sockets
      // lib.mapAttrs' (_: withName targetToUnit) cfg.targets
      // lib.mapAttrs' (_: withName timerToUnit) cfg.timers
      // lib.listToAttrs (map (withName mountToUnit) cfg.mounts)
      // lib.listToAttrs (map (withName automountToUnit) cfg.automounts);

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


    system.requiredKernelConfig = lib.map config.lib.kernelConfig.isEnabled
      [ "DEVTMPFS" "CGROUPS" "INOTIFY_USER" "SIGNALFD" "TIMERFD" "EPOLL" "NET"
        "SYSFS" "PROC_FS" "FHANDLE" "CRYPTO_USER_API_HASH" "CRYPTO_HMAC"
        "CRYPTO_SHA256" "DMIID" "AUTOFS_FS" "TMPFS_POSIX_ACL"
        "TMPFS_XATTR" "SECCOMP"
      ];

    # Generate timer units for all services that have a ‘startAt’ value.
    systemd.timers =
      lib.mapAttrs (name: service:
        { wantedBy = [ "timers.target" ];
          timerConfig.OnCalendar = service.startAt;
        })
        (lib.filterAttrs (name: service: service.enable && service.startAt != []) cfg.services);

    # Some overrides to upstream units.
    systemd.services."systemd-backlight@".restartIfChanged = false;
    systemd.services."systemd-fsck@".restartIfChanged = false;
    systemd.services."systemd-fsck@".path = [ pkgs.util-linux ] ++ config.system.fsPackages;
    systemd.services."systemd-makefs@" = {
      restartIfChanged = false;
      path = [ pkgs.util-linux ] ++ config.system.fsPackages;
      # Since there is no /etc/systemd/system/systemd-makefs@.service
      # file, the units generated in /run/systemd/generator would
      # override anything we put here. But by forcing the use of a
      # drop-in in /etc, it does apply.
      overrideStrategy = "asDropin";
    };
    systemd.services."systemd-mkswap@" = {
      restartIfChanged = false;
      path = [ pkgs.util-linux ];
      overrideStrategy = "asDropin";
    };
    systemd.services.systemd-random-seed.restartIfChanged = false;
    systemd.services.systemd-remount-fs.restartIfChanged = false;
    systemd.services.systemd-update-utmp.restartIfChanged = false;
    systemd.services.systemd-udev-settle.restartIfChanged = false; # Causes long delays in nixos-rebuild
    systemd.targets.local-fs.unitConfig.X-StopOnReconfiguration = true;
    systemd.targets.remote-fs.unitConfig.X-StopOnReconfiguration = true;
    systemd.services.systemd-importd.environment = proxy_env;
    systemd.services.systemd-pstore.wantedBy = [ "sysinit.target" ]; # see #81138

    # NixOS has kernel modules in a different location, so override that here.
    systemd.services.kmod-static-nodes.unitConfig.ConditionFileNotEmpty = [
      ""  # required to unset the previous value!
      "/run/booted-system/kernel-modules/lib/modules/%v/modules.devname"
    ];

    # Don't bother with certain units in containers.
    systemd.services.systemd-remount-fs.unitConfig.ConditionVirtualization = "!container";

    # Increase numeric PID range (set directly instead of copying a one-line file from systemd)
    # https://github.com/systemd/systemd/pull/12226
    boot.kernel.sysctl."kernel.pid_max" = lib.mkIf pkgs.stdenv.hostPlatform.is64bit (lib.mkDefault 4194304);

    services.logrotate.settings = {
      "/var/log/btmp" = lib.mapAttrs (_: lib.mkDefault) {
        frequency = "monthly";
        rotate = 1;
        create = "0660 root ${config.users.groups.utmp.name}";
        minsize = "1M";
      };
      "/var/log/wtmp" = lib.mapAttrs (_: lib.mkDefault) {
        frequency = "monthly";
        rotate = 1;
        create = "0664 root ${config.users.groups.utmp.name}";
        minsize = "1M";
      };
    };
  };

  # FIXME: Remove these eventually.
  imports =
    [ (lib.mkRenamedOptionModule [ "boot" "systemd" "sockets" ] [ "systemd" "sockets" ])
      (lib.mkRenamedOptionModule [ "boot" "systemd" "targets" ] [ "systemd" "targets" ])
      (lib.mkRenamedOptionModule [ "boot" "systemd" "services" ] [ "systemd" "services" ])
      (lib.mkRenamedOptionModule [ "jobs" ] [ "systemd" "services" ])
      (lib.mkRemovedOptionModule [ "systemd" "generator-packages" ] "Use systemd.packages instead.")
      (lib.mkRemovedOptionModule ["systemd" "enableUnifiedCgroupHierarchy"] ''
          In 256 support for cgroup v1 ('legacy' and 'hybrid' hierarchies) is now considered obsolete and systemd by default will refuse to boot under it.
          To forcibly reenable cgroup v1 support, you can set boot.kernelParams = [ "systemd.unified_cgroup_hierachy=0" "SYSTEMD_CGROUP_ENABLE_LEGACY_FORCE=1" ].
          NixOS does not officially support this configuration and might cause your system to be unbootable in future versions. You are on your own.
      '')
    ];
}
