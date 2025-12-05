{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

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
    sliceToUnit
    settingsToSections
    ;

  upstreamSystemUnits = [
    # Targets.
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
  ]
  ++ optionals cfg.package.withCryptsetup [
    "cryptsetup.target"
    "cryptsetup-pre.target"
    "remote-cryptsetup.target"
  ]
  ++ [
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
  ]
  ++ (optional (!config.boot.isContainer) "systemd-udev-trigger.service")
  ++ [
    # hwdb.bin is managed by NixOS
    # "systemd-hwdb-update.service"

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
  ]
  ++ (optional (!config.boot.isContainer) "sys-kernel-config.mount")
  ++ [
    "sys-kernel-debug.mount"
    "sys-kernel-tracing.mount"

    # Maintaining state across reboots.
    "systemd-random-seed.service"
  ]
  ++ optionals cfg.package.withBootloader [
    "systemd-boot-random-seed.service"
    "systemd-bless-boot.service"
  ]
  ++ [
    "systemd-backlight@.service"
    "systemd-rfkill.service"
    "systemd-rfkill.socket"

    "boot-complete.target"

    # Hibernate / suspend.
    "hibernate.target"
    "suspend.target"
    "suspend-then-hibernate.target"
    "sleep.target"
    "hybrid-sleep.target"
    "systemd-hibernate.service"
  ]
  ++ (lib.optional cfg.package.withEfi "systemd-hibernate-clear.service")
  ++ [
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
  ]
  ++ lib.optional cfg.package.withUtmp "systemd-update-utmp.service"
  ++ [

    # Password entry.
    "systemd-ask-password-console.path"
    "systemd-ask-password-console.service"
    "systemd-ask-password-wall.path"
    "systemd-ask-password-wall.service"

    # Varlink APIs
  ]
  ++ lib.optionals cfg.package.withBootloader [
    "systemd-bootctl@.service"
    "systemd-bootctl.socket"
  ]
  ++ [
    "systemd-creds@.service"
    "systemd-creds.socket"
  ]
  ++ lib.optional cfg.package.withTpm2Units [
    "systemd-pcrlock@.service"
    "systemd-pcrlock.socket"
  ]
  ++ [

    # Slices / containers.
    "slices.target"
  ]
  ++ optionals cfg.package.withImportd [
    "systemd-importd.service"
  ]
  ++ optionals cfg.package.withMachined [
    "machine.slice"
    "machines.target"
    "systemd-machined.service"
  ]
  ++ [
    "systemd-nspawn@.service"

    # Misc.
    "systemd-sysctl.service"
    "systemd-machine-id-commit.service"
  ]
  ++ optionals cfg.package.withTimedated [
    "dbus-org.freedesktop.timedate1.service"
    "systemd-timedated.service"
  ]
  ++ optionals cfg.package.withLocaled [
    "dbus-org.freedesktop.locale1.service"
    "systemd-localed.service"
  ]
  ++ optionals cfg.package.withHostnamed [
    "dbus-org.freedesktop.hostname1.service"
    "systemd-hostnamed.service"
    "systemd-hostnamed.socket"
  ]
  ++ optionals cfg.package.withPortabled [
    "dbus-org.freedesktop.portable1.service"
    "systemd-portabled.service"
  ]
  ++ [
    "systemd-exit.service"
    "systemd-update-done.service"

    # Capsule support
    "capsule@.service"
    "capsule.slice"
  ]
  ++ cfg.additionalUpstreamSystemUnits;

  upstreamSystemWants = [
    "sysinit.target.wants"
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

    package = mkPackageOption pkgs "systemd" { };

    enableStrictShellChecks = mkEnableOption "" // {
      description = ''
        Whether to run `shellcheck` on the generated scripts for systemd
        units.

        When enabled, all systemd scripts generated by NixOS will be checked
        with `shellcheck` and any errors or warnings will cause the build to
        fail.

        This affects all scripts that have been created through the `script`,
        `reload`, `preStart`, `postStart`, `preStop` and `postStop` options for
        systemd services. This does not affect command lines passed directly
        to `ExecStart`, `ExecReload`, `ExecStartPre`, `ExecStartPost`,
        `ExecStop` or `ExecStopPost`.

        It therefore also does not affect systemd units that are coming from
        packages and that are not defined through the NixOS config. This option
        is disabled by default, and although some services have already been
        fixed, it is still likely that you will encounter build failures when
        enabling this.

        We encourage people to enable this option when they are willing and
        able to submit fixes for potential build failures to Nixpkgs. The
        option can also be enabled or disabled for individual services using
        the `enableStrictShellChecks` option on the service itself, which will
        take precedence over the global setting.
      '';
    };

    units = mkOption {
      description = "Definition of systemd units; see {manpage}`systemd.unit(5)`.";
      default = { };
      type = systemdUtils.types.units;
    };

    packages = mkOption {
      default = [ ];
      type = types.listOf types.package;
      example = literalExpression "[ pkgs.systemd-cryptsetup-generator ]";
      description = "Packages providing systemd units and hooks.";
    };

    targets = mkOption {
      default = { };
      type = systemdUtils.types.targets;
      description = "Definition of systemd target units; see {manpage}`systemd.target(5)`";
    };

    services = mkOption {
      default = { };
      type = systemdUtils.types.services;
      description = "Definition of systemd service units; see {manpage}`systemd.service(5)`.";
    };

    sockets = mkOption {
      default = { };
      type = systemdUtils.types.sockets;
      description = "Definition of systemd socket units; see {manpage}`systemd.socket(5)`.";
    };

    timers = mkOption {
      default = { };
      type = systemdUtils.types.timers;
      description = "Definition of systemd timer units; see {manpage}`systemd.timer(5)`.";
    };

    paths = mkOption {
      default = { };
      type = systemdUtils.types.paths;
      description = "Definition of systemd path units; see {manpage}`systemd.path(5)`.";
    };

    mounts = mkOption {
      default = [ ];
      type = systemdUtils.types.mounts;
      description = ''
        Definition of systemd mount units; see {manpage}`systemd.mount(5)`.

        This is a list instead of an attrSet, because systemd mandates
        the names to be derived from the `where` attribute.
      '';
    };

    automounts = mkOption {
      default = [ ];
      type = systemdUtils.types.automounts;
      description = ''
        Definition of systemd automount units; see {manpage}`systemd.automount(5)`.

        This is a list instead of an attrSet, because systemd mandates
        the names to be derived from the `where` attribute.
      '';
    };

    slices = mkOption {
      default = { };
      type = systemdUtils.types.slices;
      description = "Definition of slice configurations; see {manpage}`systemd.slice(5)`.";
    };

    generators = mkOption {
      type = types.attrsOf types.path;
      default = { };
      example = {
        systemd-gpt-auto-generator = "/dev/null";
      };
      description = ''
        Definition of systemd generators; see {manpage}`systemd.generator(5)`.

        For each `NAME = VALUE` pair of the attrSet, a link is generated from
        `/etc/systemd/system-generators/NAME` to `VALUE`.
      '';
    };

    shutdown = mkOption {
      type = types.attrsOf types.path;
      default = { };
      description = ''
        Definition of systemd shutdown executables.
        For each `NAME = VALUE` pair of the attrSet, a link is generated from
        `/etc/systemd/system-shutdown/NAME` to `VALUE`.
      '';
    };

    defaultUnit = mkOption {
      default = "multi-user.target";
      type = types.str;
      description = ''
        Default unit started when the system boots; see {manpage}`systemd.special(7)`.
      '';
    };

    ctrlAltDelUnit = mkOption {
      default = "reboot.target";
      type = types.str;
      example = "poweroff.target";
      description = ''
        Target that should be started when Ctrl-Alt-Delete is pressed;
        see {manpage}`systemd.special(7)`.
      '';
    };

    globalEnvironment = mkOption {
      type =
        with types;
        attrsOf (
          nullOr (oneOf [
            str
            path
            package
          ])
        );
      default = { };
      example = {
        TZ = "CET";
      };
      description = ''
        Environment variables passed to *all* systemd units.
      '';
    };

    managerEnvironment = mkOption {
      type =
        with types;
        attrsOf (
          nullOr (oneOf [
            str
            path
            package
          ])
        );
      default = { };
      example = {
        SYSTEMD_LOG_LEVEL = "debug";
      };
      description = ''
        Environment variables of PID 1. These variables are
        *not* passed to started units.
      '';
    };

    settings.Manager = mkOption {
      default = { };
      defaultText = lib.literalExpression ''
        {
          DefaultIOAccounting = true;
          DefaultIPAccounting = true;
        }
      '';
      type = lib.types.submodule {
        freeformType = types.attrsOf unitOption;
      };
      example = {
        WatchdogDevice = "/dev/watchdog";
        RuntimeWatchdogSec = "30s";
        RebootWatchdogSec = "10min";
        KExecWatchdogSec = "5min";
      };
      description = ''
        Options for the global systemd service manager. See {manpage}`systemd-system.conf(5)` man page
        for available options.
      '';
    };

    sleep.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "HibernateDelaySec=1h";
      description = ''
        Extra config options for systemd sleep state logic.
        See {manpage}`sleep.conf.d(5)` man page for available options.
      '';
    };

    additionalUpstreamSystemUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [
        "debug-shell.service"
        "systemd-quotacheck.service"
      ];
      description = ''
        Additional units shipped with systemd that shall be enabled.
      '';
    };

    suppressedSystemUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [ "systemd-backlight@.service" ];
      description = ''
        A list of units to skip when generating system systemd configuration directory. This has
        priority over upstream units, {option}`systemd.units`, and
        {option}`systemd.additionalUpstreamSystemUnits`. The main purpose of this is to
        prevent a upstream systemd unit from being added to the initrd with any modifications made to it
        by other NixOS modules.
      '';
    };
  };

  ###### implementation

  config = {

    warnings =
      let
        mkOneNetOnlineWarn =
          typeStr: name: def:
          lib.optional (
            lib.elem "network-online.target" def.after
            && !(lib.elem "network-online.target" (def.wants ++ def.requires ++ def.bindsTo))
          ) "${name}.${typeStr} is ordered after 'network-online.target' but doesn't depend on it";
        mkNetOnlineWarns =
          typeStr: defs: lib.concatLists (lib.mapAttrsToList (mkOneNetOnlineWarn typeStr) defs);
        mkMountNetOnlineWarns =
          typeStr: defs: lib.concatLists (map (m: mkOneNetOnlineWarn typeStr m.what m) defs);
      in
      concatLists (
        mapAttrsToList (
          name: service:
          let
            type = service.serviceConfig.Type or "";
            restart = service.serviceConfig.Restart or "no";
            hasDeprecated = builtins.hasAttr "StartLimitInterval" service.serviceConfig;
          in
          concatLists [
            (optional (type == "oneshot" && (restart == "always" || restart == "on-success"))
              "Service '${name}.service' with 'Type=oneshot' cannot have 'Restart=always' or 'Restart=on-success'"
            )
            (optional hasDeprecated "Service '${name}.service' uses the attribute 'StartLimitInterval' in the Service section, which is deprecated. See https://github.com/NixOS/nixpkgs/issues/45786.")
            (optional (service.reloadIfChanged && service.reloadTriggers != [ ])
              "Service '${name}.service' has both 'reloadIfChanged' and 'reloadTriggers' set. This is probably not what you want, because 'reloadTriggers' behave the same whay as 'restartTriggers' if 'reloadIfChanged' is set."
            )
          ]
        ) cfg.services
      )
      ++ (mkNetOnlineWarns "target" cfg.targets)
      ++ (mkNetOnlineWarns "service" cfg.services)
      ++ (mkNetOnlineWarns "socket" cfg.sockets)
      ++ (mkNetOnlineWarns "timer" cfg.timers)
      ++ (mkNetOnlineWarns "path" cfg.paths)
      ++ (mkMountNetOnlineWarns "mount" cfg.mounts)
      ++ (mkMountNetOnlineWarns "automount" cfg.automounts)
      ++ (mkNetOnlineWarns "slice" cfg.slices);

    assertions = concatLists (
      mapAttrsToList (
        name: service:
        map
          (message: {
            assertion = false;
            inherit message;
          })
          (concatLists [
            (optional
              (
                (builtins.elem "network-interfaces.target" service.after)
                || (builtins.elem "network-interfaces.target" service.wants)
              )
              "Service '${name}.service' is using the deprecated target network-interfaces.target, which no longer exists. Using network.target is recommended instead."
            )
          ])
      ) cfg.services
    );

    system.build.units = cfg.units;

    system.nssModules = [ cfg.package.out ];
    system.nssDatabases = {
      hosts = (
        mkMerge [
          (mkOrder 400 [ "mymachines" ]) # 400 to ensure it comes before resolve (which is 501)
          (mkOrder 999 [ "myhostname" ]) # after files (which is 998), but before regular nss modules
        ]
      );
      passwd = (
        mkMerge [
          (mkAfter [ "systemd" ])
        ]
      );
      group = (
        mkMerge [
          (mkAfter [ "[success=merge] systemd" ]) # need merge so that NSS won't stop at file-based groups
        ]
      );
      shadow = (
        mkMerge [
          (mkAfter [ "systemd" ])
        ]
      );
    };

    environment.systemPackages = [ cfg.package ];

    environment.etc =
      let
        # generate contents for /etc/systemd/${dir} from attrset of links and packages
        hooks =
          dir: links:
          pkgs.runCommand "${dir}"
            {

              packages = cfg.packages;
            }
            ''
              set -e
              mkdir -p $out
              for package in $packages
              do
                for hook in $package/lib/systemd/${dir}/*
                do
                  ln -s $hook $out/
                done
              done
              ${concatStrings (mapAttrsToList (exec: target: "ln -s ${target} $out/${exec};\n") links)}
            '';

        enabledUpstreamSystemUnits = filter (n: !elem n cfg.suppressedSystemUnits) upstreamSystemUnits;
        enabledUnits = removeAttrs cfg.units cfg.suppressedSystemUnits;

      in
      {
        "systemd/system".source = generateUnits {
          type = "system";
          units = enabledUnits;
          upstreamUnits = enabledUpstreamSystemUnits;
          upstreamWants = upstreamSystemWants;
        };

        "systemd/system.conf".text = settingsToSections cfg.settings;

        "systemd/sleep.conf".text = ''
          [Sleep]
          ${cfg.sleep.extraConfig}
        '';

        "systemd/user-generators" = {
          source = hooks "user-generators" cfg.user.generators;
        };
        "systemd/system-generators" = {
          source = hooks "system-generators" cfg.generators;
        };
        "systemd/system-shutdown" = {
          source = hooks "system-shutdown" cfg.shutdown;
        };

        # Ignore all other preset files so systemd doesn't try to enable/disable
        # units during runtime.
        "systemd/system-preset/00-nixos.preset".text = ''
          ignore *
        '';
        "systemd/user-preset/00-nixos.preset".text = ''
          ignore *
        '';
      };

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

    systemd.targets.keys = {
      description = "Security Keys";
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
      mapAttrs' (_: withName pathToUnit) cfg.paths
      // mapAttrs' (_: withName serviceToUnit) cfg.services
      // mapAttrs' (_: withName sliceToUnit) cfg.slices
      // mapAttrs' (_: withName socketToUnit) cfg.sockets
      // mapAttrs' (_: withName targetToUnit) cfg.targets
      // mapAttrs' (_: withName timerToUnit) cfg.timers
      // listToAttrs (map (withName mountToUnit) cfg.mounts)
      // listToAttrs (map (withName automountToUnit) cfg.automounts);

    # Environment of PID 1
    systemd.managerEnvironment = {
      # Doesn't contain systemd itself - everything works so it seems to use the compiled-in value for its tools
      # util-linux is needed for the main fsck utility wrapping the fs-specific ones
      PATH = lib.makeBinPath (
        config.system.fsPackages
        ++ [ cfg.package.util-linux ]
        # systemd-ssh-generator needs sshd in PATH
        ++ lib.optional config.services.openssh.enable config.services.openssh.package
      );
      LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
      TZDIR = "/etc/zoneinfo";
      # If SYSTEMD_UNIT_PATH ends with an empty component (":"), the usual unit load path will be appended to the contents of the variable
      SYSTEMD_UNIT_PATH = lib.mkIf (
        config.boot.extraSystemdUnitPaths != [ ]
      ) "${builtins.concatStringsSep ":" config.boot.extraSystemdUnitPaths}:";
    };
    systemd.settings.Manager = {
      ManagerEnvironment = lib.concatStringsSep " " (
        lib.mapAttrsToList (n: v: "${n}=${lib.escapeShellArg v}") cfg.managerEnvironment
      );
      DefaultIOAccounting = lib.mkDefault true;
      DefaultIPAccounting = lib.mkDefault true;
    };

    system.requiredKernelConfig = map config.lib.kernelConfig.isEnabled [
      "DEVTMPFS"
      "CGROUPS"
      "INOTIFY_USER"
      "SIGNALFD"
      "TIMERFD"
      "EPOLL"
      "NET"
      "SYSFS"
      "PROC_FS"
      "FHANDLE"
      "CRYPTO_USER_API_HASH"
      "CRYPTO_HMAC"
      "CRYPTO_SHA256"
      "DMIID"
      "AUTOFS_FS"
      "TMPFS_POSIX_ACL"
      "TMPFS_XATTR"
      "SECCOMP"
    ];

    # Generate timer units for all services that have a ‘startAt’ value.
    systemd.timers = mapAttrs (name: service: {
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = service.startAt;
    }) (filterAttrs (name: service: service.enable && service.startAt != [ ]) cfg.services);

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
      "" # required to unset the previous value!
      "/run/booted-system/kernel-modules/lib/modules/%v/modules.devname"
    ];

    # Don't bother with certain units in containers.
    systemd.services.systemd-remount-fs.unitConfig.ConditionVirtualization = "!container";

    # Increase numeric PID range (set directly instead of copying a one-line file from systemd)
    # https://github.com/systemd/systemd/pull/12226
    boot.kernel.sysctl."kernel.pid_max" = mkIf pkgs.stdenv.hostPlatform.is64bit (lib.mkDefault 4194304);

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

    # run0 is supposed to authenticate the user via polkit and then run a command. Without this next
    # part, run0 would fail to run the command even if authentication is successful and the user has
    # permission to run the command. This next part is only enabled if polkit is enabled because the
    # error that we’re trying to avoid can’t possibly happen if polkit isn’t enabled. When polkit isn’t
    # enabled, run0 will fail before it even tries to run the command.
    security.pam.services = mkIf config.security.polkit.enable {
      systemd-run0 = {
        # Upstream config: https://github.com/systemd/systemd/blob/main/src/run/systemd-run0.in
        setLoginUid = true;
        pamMount = false;
      };
    };
  };

  # FIXME: Remove these eventually.
  imports = [
    (mkRenamedOptionModule [ "boot" "systemd" "sockets" ] [ "systemd" "sockets" ])
    (mkRenamedOptionModule [ "boot" "systemd" "targets" ] [ "systemd" "targets" ])
    (mkRenamedOptionModule [ "boot" "systemd" "services" ] [ "systemd" "services" ])
    (mkRenamedOptionModule [ "jobs" ] [ "systemd" "services" ])
    (mkRemovedOptionModule [ "systemd" "generator-packages" ] "Use systemd.packages instead.")
    (mkRemovedOptionModule [ "systemd" "enableUnifiedCgroupHierarchy" ] ''
      In 256 support for cgroup v1 ('legacy' and 'hybrid' hierarchies) is now considered obsolete and systemd by default will refuse to boot under it.
      To forcibly reenable cgroup v1 support, you can set boot.kernelParams = [ "systemd.unified_cgroup_hierarchy=0" "SYSTEMD_CGROUP_ENABLE_LEGACY_FORCE=1" ].
      NixOS does not officially support this configuration and might cause your system to be unbootable in future versions. You are on your own.
    '')
    (mkRemovedOptionModule [ "systemd" "extraConfig" ] "Use systemd.settings.Manager instead.")
    (lib.mkRenamedOptionModule
      [ "systemd" "watchdog" "device" ]
      [ "systemd" "settings" "Manager" "WatchdogDevice" ]
    )
    (lib.mkRenamedOptionModule
      [ "systemd" "watchdog" "runtimeTime" ]
      [ "systemd" "settings" "Manager" "RuntimeWatchdogSec" ]
    )
    (lib.mkRenamedOptionModule
      [ "systemd" "watchdog" "rebootTime" ]
      [ "systemd" "settings" "Manager" "RebootWatchdogSec" ]
    )
    (lib.mkRenamedOptionModule
      [ "systemd" "watchdog" "kexecTime" ]
      [ "systemd" "settings" "Manager" "KExecWatchdogSec" ]
    )
    (mkRemovedOptionModule [
      "systemd"
      "enableCgroupAccounting"
    ] "To disable cgroup accounting, disable systemd.settings.Manager.*Accounting directly.")
  ];
}
