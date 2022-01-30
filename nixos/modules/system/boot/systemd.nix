{ config, lib, pkgs, utils, ... }:

with utils;
with systemdUtils.unitOptions;
with systemdUtils.lib;
with lib;

let

  cfg = config.systemd;

  systemd = cfg.package;

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
    ] ++ (optionals cfg.package.withCryptsetup [
      "cryptsetup.target"
      "cryptsetup-pre.target"
      "remote-cryptsetup.target"
    ]) ++ [
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

      # Login stuff.
      "systemd-logind.service"
      "autovt@.service"
      "systemd-user-sessions.service"
      "dbus-org.freedesktop.import1.service"
      "dbus-org.freedesktop.machine1.service"
      "dbus-org.freedesktop.login1.service"
      "user@.service"
      "user-runtime-dir@.service"

      # Journal.
      "systemd-journald.socket"
      "systemd-journald@.socket"
      "systemd-journald-varlink@.socket"
      "systemd-journald.service"
      "systemd-journald@.service"
      "systemd-journal-flush.service"
      "systemd-journal-catalog-update.service"
      ] ++ (optional (!config.boot.isContainer) "systemd-journald-audit.socket") ++ [
      "systemd-journald-dev-log.socket"
      "syslog.socket"

      # Coredumps.
      "systemd-coredump.socket"
      "systemd-coredump@.service"

      # Kernel module loading.
      "systemd-modules-load.service"
      "kmod-static-nodes.service"
      "modprobe@.service"

      # Filesystems.
      "systemd-fsck@.service"
      "systemd-fsck-root.service"
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
      "systemd-update-utmp.service"

      # Password entry.
      "systemd-ask-password-console.path"
      "systemd-ask-password-console.service"
      "systemd-ask-password-wall.path"
      "systemd-ask-password-wall.service"

      # Slices / containers.
      "slices.target"
      "user.slice"
      "machine.slice"
      "machines.target"
      "systemd-importd.service"
      "systemd-machined.service"
      "systemd-nspawn@.service"

      # Temporary file creation / cleanup.
      "systemd-tmpfiles-clean.service"
      "systemd-tmpfiles-clean.timer"
      "systemd-tmpfiles-setup.service"
      "systemd-tmpfiles-setup-dev.service"

      # Misc.
      "systemd-sysctl.service"
      "dbus-org.freedesktop.timedate1.service"
      "dbus-org.freedesktop.locale1.service"
      "dbus-org.freedesktop.hostname1.service"
      "systemd-timedated.service"
      "systemd-localed.service"
      "systemd-hostnamed.service"
      "systemd-exit.service"
      "systemd-update-done.service"
    ] ++ optionals config.services.journald.enableHttpGateway [
      "systemd-journal-gatewayd.socket"
      "systemd-journal-gatewayd.service"
    ] ++ cfg.additionalUpstreamSystemUnits;

  upstreamSystemWants =
    [ "sysinit.target.wants"
      "sockets.target.wants"
      "local-fs.target.wants"
      "multi-user.target.wants"
      "timers.target.wants"
    ];

    upstreamUserUnits = [
      "app.slice"
      "background.slice"
      "basic.target"
      "bluetooth.target"
      "default.target"
      "exit.target"
      "graphical-session-pre.target"
      "graphical-session.target"
      "paths.target"
      "printer.target"
      "session.slice"
      "shutdown.target"
      "smartcard.target"
      "sockets.target"
      "sound.target"
      "systemd-exit.service"
      "systemd-tmpfiles-clean.service"
      "systemd-tmpfiles-clean.timer"
      "systemd-tmpfiles-setup.service"
      "timers.target"
      "xdg-desktop-autostart.target"
    ];

  makeJobScript = name: text:
    let
      scriptName = replaceChars [ "\\" "@" ] [ "-" "_" ] (shellEscape name);
      out = (pkgs.writeShellScriptBin scriptName ''
        set -e
        ${text}
      '').overrideAttrs (_: {
        # The derivation name is different from the script file name
        # to keep the script file name short to avoid cluttering logs.
        name = "unit-script-${scriptName}";
      });
    in "${out}/bin/${scriptName}";

  unitConfig = { config, options, ... }: {
    config = {
      unitConfig =
        optionalAttrs (config.requires != [])
          { Requires = toString config.requires; }
        // optionalAttrs (config.wants != [])
          { Wants = toString config.wants; }
        // optionalAttrs (config.after != [])
          { After = toString config.after; }
        // optionalAttrs (config.before != [])
          { Before = toString config.before; }
        // optionalAttrs (config.bindsTo != [])
          { BindsTo = toString config.bindsTo; }
        // optionalAttrs (config.partOf != [])
          { PartOf = toString config.partOf; }
        // optionalAttrs (config.conflicts != [])
          { Conflicts = toString config.conflicts; }
        // optionalAttrs (config.requisite != [])
          { Requisite = toString config.requisite; }
        // optionalAttrs (config.restartTriggers != [])
          { X-Restart-Triggers = toString config.restartTriggers; }
        // optionalAttrs (config.description != "") {
          Description = config.description; }
        // optionalAttrs (config.documentation != []) {
          Documentation = toString config.documentation; }
        // optionalAttrs (config.onFailure != []) {
          OnFailure = toString config.onFailure; }
        // optionalAttrs (options.startLimitIntervalSec.isDefined) {
          StartLimitIntervalSec = toString config.startLimitIntervalSec;
        } // optionalAttrs (options.startLimitBurst.isDefined) {
          StartLimitBurst = toString config.startLimitBurst;
        };
    };
  };

  serviceConfig = { name, config, ... }: {
    config = mkMerge
      [ { # Default path for systemd services.  Should be quite minimal.
          path = mkAfter
            [ pkgs.coreutils
              pkgs.findutils
              pkgs.gnugrep
              pkgs.gnused
              systemd
            ];
          environment.PATH = "${makeBinPath config.path}:${makeSearchPathOutput "bin" "sbin" config.path}";
        }
        (mkIf (config.preStart != "")
          { serviceConfig.ExecStartPre =
              [ (makeJobScript "${name}-pre-start" config.preStart) ];
          })
        (mkIf (config.script != "")
          { serviceConfig.ExecStart =
              makeJobScript "${name}-start" config.script + " " + config.scriptArgs;
          })
        (mkIf (config.postStart != "")
          { serviceConfig.ExecStartPost =
              [ (makeJobScript "${name}-post-start" config.postStart) ];
          })
        (mkIf (config.reload != "")
          { serviceConfig.ExecReload =
              makeJobScript "${name}-reload" config.reload;
          })
        (mkIf (config.preStop != "")
          { serviceConfig.ExecStop =
              makeJobScript "${name}-pre-stop" config.preStop;
          })
        (mkIf (config.postStop != "")
          { serviceConfig.ExecStopPost =
              makeJobScript "${name}-post-stop" config.postStop;
          })
      ];
  };

  mountConfig = { config, ... }: {
    config = {
      mountConfig =
        { What = config.what;
          Where = config.where;
        } // optionalAttrs (config.type != "") {
          Type = config.type;
        } // optionalAttrs (config.options != "") {
          Options = config.options;
        };
    };
  };

  automountConfig = { config, ... }: {
    config = {
      automountConfig =
        { Where = config.where;
        };
    };
  };

  commonUnitText = def: ''
      [Unit]
      ${attrsToSection def.unitConfig}
    '';

  targetToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable;
      text =
        ''
          [Unit]
          ${attrsToSection def.unitConfig}
        '';
    };

  serviceToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Service]
          ${let env = cfg.globalEnvironment // def.environment;
            in concatMapStrings (n:
              let s = optionalString (env.${n} != null)
                "Environment=${builtins.toJSON "${n}=${env.${n}}"}\n";
              # systemd max line length is now 1MiB
              # https://github.com/systemd/systemd/commit/e6dde451a51dc5aaa7f4d98d39b8fe735f73d2af
              in if stringLength s >= 1048576 then throw "The value of the environment variable ‘${n}’ in systemd service ‘${name}.service’ is too long." else s) (attrNames env)}
          ${if def.reloadIfChanged then ''
            X-ReloadIfChanged=true
          '' else if !def.restartIfChanged then ''
            X-RestartIfChanged=false
          '' else ""}
          ${optionalString (!def.stopIfChanged) "X-StopIfChanged=false"}
          ${attrsToSection def.serviceConfig}
        '';
    };

  socketToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Socket]
          ${attrsToSection def.socketConfig}
          ${concatStringsSep "\n" (map (s: "ListenStream=${s}") def.listenStreams)}
          ${concatStringsSep "\n" (map (s: "ListenDatagram=${s}") def.listenDatagrams)}
        '';
    };

  timerToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Timer]
          ${attrsToSection def.timerConfig}
        '';
    };

  pathToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Path]
          ${attrsToSection def.pathConfig}
        '';
    };

  mountToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Mount]
          ${attrsToSection def.mountConfig}
        '';
    };

  automountToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Automount]
          ${attrsToSection def.automountConfig}
        '';
    };

  sliceToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Slice]
          ${attrsToSection def.sliceConfig}
        '';
    };

  logindHandlerType = types.enum [
    "ignore" "poweroff" "reboot" "halt" "kexec" "suspend"
    "hibernate" "hybrid-sleep" "suspend-then-hibernate" "lock"
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
      description = "The systemd package.";
    };

    systemd.units = mkOption {
      description = "Definition of systemd units.";
      default = {};
      type = with types; attrsOf (submodule (
        { name, config, ... }:
        { options = concreteUnitOptions;
          config = {
            unit = mkDefault (makeUnit name config);
          };
        }));
    };

    systemd.packages = mkOption {
      default = [];
      type = types.listOf types.package;
      example = literalExpression "[ pkgs.systemd-cryptsetup-generator ]";
      description = "Packages providing systemd units and hooks.";
    };

    systemd.targets = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = targetOptions; } unitConfig] );
      description = "Definition of systemd target units.";
    };

    systemd.services = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = serviceOptions; } unitConfig serviceConfig ]);
      description = "Definition of systemd service units.";
    };

    systemd.sockets = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = socketOptions; } unitConfig ]);
      description = "Definition of systemd socket units.";
    };

    systemd.timers = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = timerOptions; } unitConfig ]);
      description = "Definition of systemd timer units.";
    };

    systemd.paths = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = pathOptions; } unitConfig ]);
      description = "Definition of systemd path units.";
    };

    systemd.mounts = mkOption {
      default = [];
      type = with types; listOf (submodule [ { options = mountOptions; } unitConfig mountConfig ]);
      description = ''
        Definition of systemd mount units.
        This is a list instead of an attrSet, because systemd mandates the names to be derived from
        the 'where' attribute.
      '';
    };

    systemd.automounts = mkOption {
      default = [];
      type = with types; listOf (submodule [ { options = automountOptions; } unitConfig automountConfig ]);
      description = ''
        Definition of systemd automount units.
        This is a list instead of an attrSet, because systemd mandates the names to be derived from
        the 'where' attribute.
      '';
    };

    systemd.slices = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = sliceOptions; } unitConfig] );
      description = "Definition of slice configurations.";
    };

    systemd.generators = mkOption {
      type = types.attrsOf types.path;
      default = {};
      example = { systemd-gpt-auto-generator = "/dev/null"; };
      description = ''
        Definition of systemd generators.
        For each <literal>NAME = VALUE</literal> pair of the attrSet, a link is generated from
        <literal>/etc/systemd/system-generators/NAME</literal> to <literal>VALUE</literal>.
      '';
    };

    systemd.shutdown = mkOption {
      type = types.attrsOf types.path;
      default = {};
      description = ''
        Definition of systemd shutdown executables.
        For each <literal>NAME = VALUE</literal> pair of the attrSet, a link is generated from
        <literal>/etc/systemd/system-shutdown/NAME</literal> to <literal>VALUE</literal>.
      '';
    };

    systemd.defaultUnit = mkOption {
      default = "multi-user.target";
      type = types.str;
      description = "Default unit started when the system boots.";
    };

    systemd.ctrlAltDelUnit = mkOption {
      default = "reboot.target";
      type = types.str;
      example = "poweroff.target";
      description = ''
        Target that should be started when Ctrl-Alt-Delete is pressed.
      '';
    };

    systemd.globalEnvironment = mkOption {
      type = with types; attrsOf (nullOr (oneOf [ str path package ]));
      default = {};
      example = { TZ = "CET"; };
      description = ''
        Environment variables passed to <emphasis>all</emphasis> systemd units.
      '';
    };

    systemd.enableCgroupAccounting = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable cgroup accounting.
      '';
    };

    systemd.enableUnifiedCgroupHierarchy = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable the unified cgroup hierarchy (cgroupsv2).
      '';
    };

    systemd.coredump.enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether core dumps should be processed by
        <command>systemd-coredump</command>. If disabled, core dumps
        appear in the current directory of the crashing process.
      '';
    };

    systemd.coredump.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "Storage=journal";
      description = ''
        Extra config options for systemd-coredump. See coredump.conf(5) man page
        for available options.
      '';
    };

    systemd.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "DefaultLimitCORE=infinity";
      description = ''
        Extra config options for systemd. See man systemd-system.conf for
        available options.
      '';
    };

    services.journald.console = mkOption {
      default = "";
      type = types.str;
      description = "If non-empty, write log messages to the specified TTY device.";
    };

    services.journald.rateLimitInterval = mkOption {
      default = "30s";
      type = types.str;
      description = ''
        Configures the rate limiting interval that is applied to all
        messages generated on the system. This rate limiting is applied
        per-service, so that two services which log do not interfere with
        each other's limit. The value may be specified in the following
        units: s, min, h, ms, us. To turn off any kind of rate limiting,
        set either value to 0.

        See <option>services.journald.rateLimitBurst</option> for important
        considerations when setting this value.
      '';
    };

    services.journald.rateLimitBurst = mkOption {
      default = 10000;
      type = types.int;
      description = ''
        Configures the rate limiting burst limit (number of messages per
        interval) that is applied to all messages generated on the system.
        This rate limiting is applied per-service, so that two services
        which log do not interfere with each other's limit.

        Note that the effective rate limit is multiplied by a factor derived
        from the available free disk space for the journal as described on
        <link xlink:href="https://www.freedesktop.org/software/systemd/man/journald.conf.html">
        journald.conf(5)</link>.

        Note that the total amount of logs stored is limited by journald settings
        such as <literal>SystemMaxUse</literal>, which defaults to a 4 GB cap.

        It is thus recommended to compute what period of time that you will be
        able to store logs for when an application logs at full burst rate.
        With default settings for log lines that are 100 Bytes long, this can
        amount to just a few hours.
      '';
    };

    services.journald.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "Storage=volatile";
      description = ''
        Extra config options for systemd-journald. See man journald.conf
        for available options.
      '';
    };

    services.journald.enableHttpGateway = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable the HTTP gateway to the journal.
      '';
    };

    services.journald.forwardToSyslog = mkOption {
      default = config.services.rsyslogd.enable || config.services.syslog-ng.enable;
      defaultText = literalExpression "services.rsyslogd.enable || services.syslog-ng.enable";
      type = types.bool;
      description = ''
        Whether to forward log messages to syslog.
      '';
    };

    services.logind.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "IdleAction=lock";
      description = ''
        Extra config options for systemd-logind. See
        <link xlink:href="https://www.freedesktop.org/software/systemd/man/logind.conf.html">
        logind.conf(5)</link> for available options.
      '';
    };

    services.logind.killUserProcesses = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Specifies whether the processes of a user should be killed
        when the user logs out.  If true, the scope unit corresponding
        to the session and all processes inside that scope will be
        terminated.  If false, the scope is "abandoned" (see
        <link xlink:href="https://www.freedesktop.org/software/systemd/man/systemd.scope.html#">
        systemd.scope(5)</link>), and processes are not killed.
        </para>

        <para>
        See <link xlink:href="https://www.freedesktop.org/software/systemd/man/logind.conf.html#KillUserProcesses=">logind.conf(5)</link>
        for more details.
      '';
    };

    services.logind.lidSwitch = mkOption {
      default = "suspend";
      example = "ignore";
      type = logindHandlerType;

      description = ''
        Specifies what to be done when the laptop lid is closed.
      '';
    };

    services.logind.lidSwitchDocked = mkOption {
      default = "ignore";
      example = "suspend";
      type = logindHandlerType;

      description = ''
        Specifies what to be done when the laptop lid is closed
        and another screen is added.
      '';
    };

    services.logind.lidSwitchExternalPower = mkOption {
      default = config.services.logind.lidSwitch;
      defaultText = literalExpression "services.logind.lidSwitch";
      example = "ignore";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the laptop lid is closed and the system is
        on external power. By default use the same action as specified in
        services.logind.lidSwitch.
      '';
    };

    systemd.sleep.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "HibernateDelaySec=1h";
      description = ''
        Extra config options for systemd sleep state logic.
        See sleep.conf.d(5) man page for available options.
      '';
    };

    systemd.user.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "DefaultCPUAccounting=yes";
      description = ''
        Extra config options for systemd user instances. See man systemd-user.conf for
        available options.
      '';
    };

    systemd.tmpfiles.rules = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "d /tmp 1777 root root 10d" ];
      description = ''
        Rules for creation, deletion and cleaning of volatile and temporary files
        automatically. See
        <citerefentry><refentrytitle>tmpfiles.d</refentrytitle><manvolnum>5</manvolnum></citerefentry>
        for the exact format.
      '';
    };

    systemd.tmpfiles.packages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression "[ pkgs.lvm2 ]";
      apply = map getLib;
      description = ''
        List of packages containing <command>systemd-tmpfiles</command> rules.

        All files ending in .conf found in
        <filename><replaceable>pkg</replaceable>/lib/tmpfiles.d</filename>
        will be included.
        If this folder does not exist or does not contain any files an error will be returned instead.

        If a <filename>lib</filename> output is available, rules are searched there and only there.
        If there is no <filename>lib</filename> output it will fall back to <filename>out</filename>
        and if that does not exist either, the default output will be used.
      '';
    };

    systemd.user.units = mkOption {
      description = "Definition of systemd per-user units.";
      default = {};
      type = with types; attrsOf (submodule (
        { name, config, ... }:
        { options = concreteUnitOptions;
          config = {
            unit = mkDefault (makeUnit name config);
          };
        }));
    };

    systemd.user.paths = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = pathOptions; } unitConfig ]);
      description = "Definition of systemd per-user path units.";
    };

    systemd.user.services = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = serviceOptions; } unitConfig serviceConfig ] );
      description = "Definition of systemd per-user service units.";
    };

    systemd.user.slices = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = sliceOptions; } unitConfig ] );
      description = "Definition of systemd per-user slice units.";
    };

    systemd.user.sockets = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = socketOptions; } unitConfig ] );
      description = "Definition of systemd per-user socket units.";
    };

    systemd.user.targets = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = targetOptions; } unitConfig] );
      description = "Definition of systemd per-user target units.";
    };

    systemd.user.timers = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = timerOptions; } unitConfig ] );
      description = "Definition of systemd per-user timer units.";
    };

    systemd.additionalUpstreamSystemUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [ "debug-shell.service" "systemd-quotacheck.service" ];
      description = ''
        Additional units shipped with systemd that shall be enabled.
      '';
    };

    systemd.suppressedSystemUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [ "systemd-backlight@.service" ];
      description = ''
        A list of units to suppress when generating system systemd configuration directory. This has
        priority over upstream units, <option>systemd.units</option>, and
        <option>systemd.additionalUpstreamSystemUnits</option>. The main purpose of this is to
        suppress a upstream systemd unit with any modifications made to it by other NixOS modules.
      '';
    };

    systemd.watchdog.device = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/dev/watchdog";
      description = ''
        The path to a hardware watchdog device which will be managed by systemd.
        If not specified, systemd will default to /dev/watchdog.
      '';
    };

    systemd.watchdog.runtimeTime = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "30s";
      description = ''
        The amount of time which can elapse before a watchdog hardware device
        will automatically reboot the system. Valid time units include "ms",
        "s", "min", "h", "d", and "w".
      '';
    };

    systemd.watchdog.rebootTime = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "10m";
      description = ''
        The amount of time which can elapse after a reboot has been triggered
        before a watchdog hardware device will automatically reboot the system.
        Valid time units include "ms", "s", "min", "h", "d", and "w".
      '';
    };

    systemd.watchdog.kexecTime = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "10m";
      description = ''
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
            ]
        )
        cfg.services
    );

    system.build.units = cfg.units;

    system.nssModules = [ systemd.out ];
    system.nssDatabases = {
      hosts = (mkMerge [
        (mkOrder 400 ["mymachines"]) # 400 to ensure it comes before resolve (which is mkBefore'd)
        (mkOrder 999 ["myhostname"]) # after files (which is 998), but before regular nss modules
      ]);
      passwd = (mkMerge [
        (mkAfter [ "systemd" ])
      ]);
      group = (mkMerge [
        (mkAfter [ "systemd" ])
      ]);
    };

    environment.systemPackages = [ systemd ];

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
      "systemd/system".source = generateUnits "system" enabledUnits enabledUpstreamSystemUnits upstreamSystemWants;

      "systemd/user".source = generateUnits "user" cfg.user.units upstreamUserUnits [];

      "systemd/system.conf".text = ''
        [Manager]
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

      "systemd/user.conf".text = ''
        [Manager]
        ${config.systemd.user.extraConfig}
      '';

      "systemd/journald.conf".text = ''
        [Journal]
        Storage=persistent
        RateLimitInterval=${config.services.journald.rateLimitInterval}
        RateLimitBurst=${toString config.services.journald.rateLimitBurst}
        ${optionalString (config.services.journald.console != "") ''
          ForwardToConsole=yes
          TTYPath=${config.services.journald.console}
        ''}
        ${optionalString (config.services.journald.forwardToSyslog) ''
          ForwardToSyslog=yes
        ''}
        ${config.services.journald.extraConfig}
      '';

      "systemd/coredump.conf".text =
        ''
          [Coredump]
          ${config.systemd.coredump.extraConfig}
        '';

      "systemd/logind.conf".text = ''
        [Login]
        KillUserProcesses=${if config.services.logind.killUserProcesses then "yes" else "no"}
        HandleLidSwitch=${config.services.logind.lidSwitch}
        HandleLidSwitchDocked=${config.services.logind.lidSwitchDocked}
        HandleLidSwitchExternalPower=${config.services.logind.lidSwitchExternalPower}
        ${config.services.logind.extraConfig}
      '';

      "systemd/sleep.conf".text = ''
        [Sleep]
        ${config.systemd.sleep.extraConfig}
      '';

      # install provided sysctl snippets
      "sysctl.d/50-coredump.conf".source = "${systemd}/example/sysctl.d/50-coredump.conf";
      "sysctl.d/50-default.conf".source = "${systemd}/example/sysctl.d/50-default.conf";

      "tmpfiles.d".source = (pkgs.symlinkJoin {
        name = "tmpfiles.d";
        paths = map (p: p + "/lib/tmpfiles.d") cfg.tmpfiles.packages;
        postBuild = ''
          for i in $(cat $pathsPath); do
            (test -d "$i" && test $(ls "$i"/*.conf | wc -l) -ge 1) || (
              echo "ERROR: The path '$i' from systemd.tmpfiles.packages contains no *.conf files."
              exit 1
            )
          done
        '' + concatMapStrings (name: optionalString (hasPrefix "tmpfiles.d/" name) ''
          rm -f $out/${removePrefix "tmpfiles.d/" name}
        '') config.system.build.etc.passthru.targets;
      }) + "/*";

      "systemd/system-generators" = { source = hooks "generators" cfg.generators; };
      "systemd/system-shutdown" = { source = hooks "shutdown" cfg.shutdown; };
    });

    services.dbus.enable = true;

    users.users.systemd-coredump = {
      uid = config.ids.uids.systemd-coredump;
      group = "systemd-coredump";
    };
    users.groups.systemd-coredump = {};
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

    systemd.tmpfiles.packages = [
      # Default tmpfiles rules provided by systemd
      (pkgs.runCommand "systemd-default-tmpfiles" {} ''
        mkdir -p $out/lib/tmpfiles.d
        cd $out/lib/tmpfiles.d

        ln -s "${systemd}/example/tmpfiles.d/home.conf"
        ln -s "${systemd}/example/tmpfiles.d/journal-nocow.conf"
        ln -s "${systemd}/example/tmpfiles.d/static-nodes-permissions.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd-nologin.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd-nspawn.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd-tmp.conf"
        ln -s "${systemd}/example/tmpfiles.d/tmp.conf"
        ln -s "${systemd}/example/tmpfiles.d/var.conf"
        ln -s "${systemd}/example/tmpfiles.d/x11.conf"
      '')
      # User-specified tmpfiles rules
      (pkgs.writeTextFile {
        name = "nixos-tmpfiles.d";
        destination = "/lib/tmpfiles.d/00-nixos.conf";
        text = ''
          # This file is created automatically and should not be modified.
          # Please change the option ‘systemd.tmpfiles.rules’ instead.

          ${concatStringsSep "\n" cfg.tmpfiles.rules}
        '';
      })
    ];

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

    systemd.user.units =
         mapAttrs' (n: v: nameValuePair "${n}.path"    (pathToUnit    n v)) cfg.user.paths
      // mapAttrs' (n: v: nameValuePair "${n}.service" (serviceToUnit n v)) cfg.user.services
      // mapAttrs' (n: v: nameValuePair "${n}.slice"   (sliceToUnit   n v)) cfg.user.slices
      // mapAttrs' (n: v: nameValuePair "${n}.socket"  (socketToUnit  n v)) cfg.user.sockets
      // mapAttrs' (n: v: nameValuePair "${n}.target"  (targetToUnit  n v)) cfg.user.targets
      // mapAttrs' (n: v: nameValuePair "${n}.timer"   (timerToUnit   n v)) cfg.user.timers;

    system.requiredKernelConfig = map config.lib.kernelConfig.isEnabled
      [ "DEVTMPFS" "CGROUPS" "INOTIFY_USER" "SIGNALFD" "TIMERFD" "EPOLL" "NET"
        "SYSFS" "PROC_FS" "FHANDLE" "CRYPTO_USER_API_HASH" "CRYPTO_HMAC"
        "CRYPTO_SHA256" "DMIID" "AUTOFS4_FS" "TMPFS_POSIX_ACL"
        "TMPFS_XATTR" "SECCOMP"
      ];

    users.groups.systemd-journal.gid = config.ids.gids.systemd-journal;
    users.users.systemd-journal-gateway.uid = config.ids.uids.systemd-journal-gateway;
    users.users.systemd-journal-gateway.group = "systemd-journal-gateway";
    users.groups.systemd-journal-gateway.gid = config.ids.gids.systemd-journal-gateway;

    # Generate timer units for all services that have a ‘startAt’ value.
    systemd.timers =
      mapAttrs (name: service:
        { wantedBy = [ "timers.target" ];
          timerConfig.OnCalendar = service.startAt;
        })
        (filterAttrs (name: service: service.enable && service.startAt != []) cfg.services);

    # Generate timer units for all services that have a ‘startAt’ value.
    systemd.user.timers =
      mapAttrs (name: service:
        { wantedBy = [ "timers.target" ];
          timerConfig.OnCalendar = service.startAt;
        })
        (filterAttrs (name: service: service.startAt != []) cfg.user.services);

    systemd.sockets.systemd-journal-gatewayd.wantedBy =
      optional config.services.journald.enableHttpGateway "sockets.target";

    # Provide the systemd-user PAM service, required to run systemd
    # user instances.
    security.pam.services.systemd-user =
      { # Ensure that pam_systemd gets included. This is special-cased
        # in systemd to provide XDG_RUNTIME_DIR.
        startSession = true;
      };

    # Some overrides to upstream units.
    systemd.services."systemd-backlight@".restartIfChanged = false;
    systemd.services."systemd-fsck@".restartIfChanged = false;
    systemd.services."systemd-fsck@".path = [ config.system.path ];
    systemd.services."user@".restartIfChanged = false;
    systemd.services.systemd-journal-flush.restartIfChanged = false;
    systemd.services.systemd-random-seed.restartIfChanged = false;
    systemd.services.systemd-remount-fs.restartIfChanged = false;
    systemd.services.systemd-update-utmp.restartIfChanged = false;
    systemd.services.systemd-user-sessions.restartIfChanged = false; # Restart kills all active sessions.
    systemd.services.systemd-udev-settle.restartIfChanged = false; # Causes long delays in nixos-rebuild
    # Restarting systemd-logind breaks X11
    # - upstream commit: https://cgit.freedesktop.org/xorg/xserver/commit/?id=dc48bd653c7e101
    # - systemd announcement: https://github.com/systemd/systemd/blob/22043e4317ecd2bc7834b48a6d364de76bb26d91/NEWS#L103-L112
    # - this might be addressed in the future by xorg
    #systemd.services.systemd-logind.restartTriggers = [ config.environment.etc."systemd/logind.conf".source ];
    systemd.services.systemd-logind.restartIfChanged = false;
    systemd.services.systemd-logind.stopIfChanged = false;
    # The user-runtime-dir@ service is managed by systemd-logind we should not touch it or else we break the users' sessions.
    systemd.services."user-runtime-dir@".stopIfChanged = false;
    systemd.services."user-runtime-dir@".restartIfChanged = false;
    systemd.services.systemd-journald.restartTriggers = [ config.environment.etc."systemd/journald.conf".source ];
    systemd.services.systemd-journald.stopIfChanged = false;
    systemd.services."systemd-journald@".restartTriggers = [ config.environment.etc."systemd/journald.conf".source ];
    systemd.services."systemd-journald@".stopIfChanged = false;
    systemd.targets.local-fs.unitConfig.X-StopOnReconfiguration = true;
    systemd.targets.remote-fs.unitConfig.X-StopOnReconfiguration = true;
    systemd.targets.network-online.wantedBy = [ "multi-user.target" ];
    systemd.services.systemd-importd.environment = proxy_env;
    systemd.services.systemd-pstore.wantedBy = [ "sysinit.target" ]; # see #81138

    # Don't bother with certain units in containers.
    systemd.services.systemd-remount-fs.unitConfig.ConditionVirtualization = "!container";
    systemd.services.systemd-random-seed.unitConfig.ConditionVirtualization = "!container";

    boot.kernel.sysctl."kernel.core_pattern" = mkIf (!cfg.coredump.enable) "core";

    # Increase numeric PID range (set directly instead of copying a one-line file from systemd)
    # https://github.com/systemd/systemd/pull/12226
    boot.kernel.sysctl."kernel.pid_max" = mkIf pkgs.stdenv.is64bit (lib.mkDefault 4194304);

    boot.kernelParams = optional (!cfg.enableUnifiedCgroupHierarchy) "systemd.unified_cgroup_hierarchy=0";
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
