{ config, lib, pkgs, utils, ... }:

with utils;
with lib;
with import ./systemd-unit-options.nix { inherit config lib; };
with import ./systemd-lib.nix { inherit config lib pkgs; };

let

  cfg = config.systemd;

  systemd = cfg.package;

  upstreamSystemUnits =
    [ # Targets.
      "basic.target"
      "sysinit.target"
      "sockets.target"
      "graphical.target"
      "multi-user.target"
      "network.target"
      "network-pre.target"
      "network-online.target"
      "nss-lookup.target"
      "nss-user-lookup.target"
      "time-sync.target"
      #"cryptsetup.target"
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
      "systemd-udev-trigger.service"

      # Consoles.
      "getty.target"
      "getty@.service"
      "serial-getty@.service"
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
      #"systemd-vconsole-setup.service"
      "systemd-user-sessions.service"
      "dbus-org.freedesktop.login1.service"
      "dbus-org.freedesktop.machine1.service"
      "org.freedesktop.login1.busname"
      "org.freedesktop.machine1.busname"
      "user@.service"

      # Journal.
      "systemd-journald.socket"
      "systemd-journald.service"
      "systemd-journal-flush.service"
      "systemd-journal-gatewayd.socket"
      "systemd-journal-gatewayd.service"
      "systemd-journald-audit.socket"
      "systemd-journald-dev-log.socket"
      "syslog.socket"

      # SysV init compatibility.
      "systemd-initctl.socket"
      "systemd-initctl.service"

      # Kernel module loading.
      "systemd-modules-load.service"
      "kmod-static-nodes.service"

      # Filesystems.
      "systemd-fsck@.service"
      "systemd-fsck-root.service"
      "systemd-remount-fs.service"
      "local-fs.target"
      "local-fs-pre.target"
      "remote-fs.target"
      "remote-fs-pre.target"
      "swap.target"
      "dev-hugepages.mount"
      "dev-mqueue.mount"
      "proc-sys-fs-binfmt_misc.mount"
      "sys-fs-fuse-connections.mount"
      "sys-kernel-config.mount"
      "sys-kernel-debug.mount"

      # Maintaining state across reboots.
      "systemd-random-seed.service"
      "systemd-backlight@.service"
      "systemd-rfkill.service"

      # Hibernate / suspend.
      "hibernate.target"
      "suspend.target"
      "sleep.target"
      "hybrid-sleep.target"
      "systemd-hibernate.service"
      "systemd-suspend.service"
      "systemd-hybrid-sleep.service"

      # Reboot stuff.
      "reboot.target"
      "systemd-reboot.service"
      "poweroff.target"
      "systemd-poweroff.service"
      "halt.target"
      "systemd-halt.service"
      "ctrl-alt-del.target"
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
      "-.slice"
      "system.slice"
      "user.slice"
      "machine.slice"
      "systemd-machined.service"

      # Temporary file creation / cleanup.
      "systemd-tmpfiles-clean.service"
      "systemd-tmpfiles-clean.timer"
      "systemd-tmpfiles-setup.service"
      "systemd-tmpfiles-setup-dev.service"

      # Misc.
      "org.freedesktop.systemd1.busname"
      "systemd-sysctl.service"
      "dbus-org.freedesktop.timedate1.service"
      "dbus-org.freedesktop.locale1.service"
      "dbus-org.freedesktop.hostname1.service"
      "org.freedesktop.timedate1.busname"
      "org.freedesktop.locale1.busname"
      "org.freedesktop.hostname1.busname"
      "systemd-timedated.service"
      "systemd-localed.service"
      "systemd-hostnamed.service"
      "systemd-binfmt.service"
    ]

    ++ cfg.additionalUpstreamSystemUnits;

  upstreamSystemWants =
    [ #"basic.target.wants"
      "sysinit.target.wants"
      "sockets.target.wants"
      "local-fs.target.wants"
      "multi-user.target.wants"
      "timers.target.wants"
    ];

  upstreamUserUnits =
    [ "basic.target"
      "default.target"
      "exit.target"
      "paths.target"
      "shutdown.target"
      "sockets.target"
      "systemd-exit.service"
      "timers.target"
    ];

  makeJobScript = name: text:
    let mkScriptName =  s: (replaceChars [ "\\" ] [ "-" ] (shellEscape s) );
        x = pkgs.writeTextFile { name = "unit-script"; executable = true; destination = "/bin/${mkScriptName name}"; inherit text; };
    in "${x}/bin/${mkScriptName name}";

  unitConfig = { name, config, ... }: {
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
          Description = config.description;
        } // optionalAttrs (config.onFailure != []) {
          OnFailure = toString config.onFailure;
        };
    };
  };

  serviceConfig = { name, config, ... }: {
    config = mkMerge
      [ { # Default path for systemd services.  Should be quite minimal.
          path =
            [ pkgs.coreutils
              pkgs.findutils
              pkgs.gnugrep
              pkgs.gnused
              systemd
            ];
          environment.PATH = config.path;
        }
        (mkIf (config.preStart != "")
          { serviceConfig.ExecStartPre = makeJobScript "${name}-pre-start" ''
              #! ${pkgs.stdenv.shell} -e
              ${config.preStart}
            '';
          })
        (mkIf (config.script != "")
          { serviceConfig.ExecStart = makeJobScript "${name}-start" ''
              #! ${pkgs.stdenv.shell} -e
              ${config.script}
            '' + " " + config.scriptArgs;
          })
        (mkIf (config.postStart != "")
          { serviceConfig.ExecStartPost = makeJobScript "${name}-post-start" ''
              #! ${pkgs.stdenv.shell} -e
              ${config.postStart}
            '';
          })
        (mkIf (config.reload != "")
          { serviceConfig.ExecReload = makeJobScript "${name}-reload" ''
              #! ${pkgs.stdenv.shell} -e
              ${config.reload}
            '';
          })
        (mkIf (config.preStop != "")
          { serviceConfig.ExecStop = makeJobScript "${name}-pre-stop" ''
              #! ${pkgs.stdenv.shell} -e
              ${config.preStop}
            '';
          })
        (mkIf (config.postStop != "")
          { serviceConfig.ExecStopPost = makeJobScript "${name}-post-stop" ''
              #! ${pkgs.stdenv.shell} -e
              ${config.postStop}
            '';
          })
      ];
  };

  mountConfig = { name, config, ... }: {
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

  automountConfig = { name, config, ... }: {
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
    { inherit (def) wantedBy requiredBy enable;
      text =
        ''
          [Unit]
          ${attrsToSection def.unitConfig}
        '';
    };

  serviceToUnit = name: def:
    { inherit (def) wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Service]
          ${let env = cfg.globalEnvironment // def.environment;
            in concatMapStrings (n:
              let s = optionalString (env."${n}" != null)
                "Environment=\"${n}=${env.${n}}\"\n";
              in if stringLength s >= 2048 then throw "The value of the environment variable ‘${n}’ in systemd service ‘${name}.service’ is too long." else s) (attrNames env)}
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
    { inherit (def) wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Socket]
          ${attrsToSection def.socketConfig}
          ${concatStringsSep "\n" (map (s: "ListenStream=${s}") def.listenStreams)}
        '';
    };

  timerToUnit = name: def:
    { inherit (def) wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Timer]
          ${attrsToSection def.timerConfig}
        '';
    };

  pathToUnit = name: def:
    { inherit (def) wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Path]
          ${attrsToSection def.pathConfig}
        '';
    };

  mountToUnit = name: def:
    { inherit (def) wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Mount]
          ${attrsToSection def.mountConfig}
        '';
    };

  automountToUnit = name: def:
    { inherit (def) wantedBy requiredBy enable;
      text = commonUnitText def +
        ''
          [Automount]
          ${attrsToSection def.automountConfig}
        '';
    };

in

{

  ###### interface

  options = {

    systemd.package = mkOption {
      default = pkgs.systemd;
      defaultText = "pkgs.systemd";
      type = types.package;
      description = "The systemd package.";
    };

    systemd.units = mkOption {
      description = "Definition of systemd units.";
      default = {};
      type = types.attrsOf types.optionSet;
      options = { name, config, ... }:
        { options = concreteUnitOptions;
          config = {
            unit = mkDefault (makeUnit name config);
          };
        };
    };

    systemd.packages = mkOption {
      default = [];
      type = types.listOf types.package;
      description = "Packages providing systemd units.";
    };

    systemd.targets = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ targetOptions unitConfig ];
      description = "Definition of systemd target units.";
    };

    systemd.services = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ serviceOptions unitConfig serviceConfig ];
      description = "Definition of systemd service units.";
    };

    systemd.sockets = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ socketOptions unitConfig ];
      description = "Definition of systemd socket units.";
    };

    systemd.timers = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ timerOptions unitConfig ];
      description = "Definition of systemd timer units.";
    };

    systemd.paths = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ pathOptions unitConfig ];
      description = "Definition of systemd path units.";
    };

    systemd.mounts = mkOption {
      default = [];
      type = types.listOf types.optionSet;
      options = [ mountOptions unitConfig mountConfig ];
      description = ''
        Definition of systemd mount units.
        This is a list instead of an attrSet, because systemd mandates the names to be derived from
        the 'where' attribute.
      '';
    };

    systemd.automounts = mkOption {
      default = [];
      type = types.listOf types.optionSet;
      options = [ automountOptions unitConfig automountConfig ];
      description = ''
        Definition of systemd automount units.
        This is a list instead of an attrSet, because systemd mandates the names to be derived from
        the 'where' attribute.
      '';
    };

    systemd.generators = mkOption {
      type = types.attrsOf types.path;
      default = {};
      example = { "systemd-gpt-auto-generator" = "/dev/null"; };
      description = ''
        Definition of systemd generators.
        For each <literal>NAME = VALUE</literal> pair of the attrSet, a link is generated from
        <literal>/etc/systemd/system-generators/NAME</literal> to <literal>VALUE</literal>.
      '';
    };

    systemd.generator-packages = mkOption {
      default = [];
      type = types.listOf types.package;
      example = literalExample "[ pkgs.systemd-cryptsetup-generator ]";
      description = "Packages providing systemd generators.";
    };

    systemd.defaultUnit = mkOption {
      default = "multi-user.target";
      type = types.str;
      description = "Default unit started when the system boots.";
    };

    systemd.globalEnvironment = mkOption {
      type = types.attrs;
      default = {};
      example = { TZ = "CET"; };
      description = ''
        Environment variables passed to <emphasis>all</emphasis> systemd units.
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
      default = "10s";
      type = types.str;
      description = ''
        Configures the rate limiting interval that is applied to all
        messages generated on the system. This rate limiting is applied
        per-service, so that two services which log do not interfere with
        each other's limit. The value may be specified in the following
        units: s, min, h, ms, us. To turn off any kind of rate limiting,
        set either value to 0.
      '';
    };

    services.journald.rateLimitBurst = mkOption {
      default = 100;
      type = types.int;
      description = ''
        Configures the rate limiting burst limit (number of messages per
        interval) that is applied to all messages generated on the system.
        This rate limiting is applied per-service, so that two services
        which log do not interfere with each other's limit.
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

    services.logind.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "HandleLidSwitch=ignore";
      description = ''
        Extra config options for systemd-logind. See man logind.conf for
        available options.
      '';
    };

    systemd.tmpfiles.rules = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "d /tmp 1777 root root 10d" ];
      description = ''
        Rules for creating and cleaning up temporary files
        automatically. See
        <citerefentry><refentrytitle>tmpfiles.d</refentrytitle><manvolnum>5</manvolnum></citerefentry>
        for the exact format. You should not use this option to create
        files required by systemd services, since there is no
        guarantee that <command>systemd-tmpfiles</command> runs when
        the system is reconfigured using
        <command>nixos-rebuild</command>.
      '';
    };

    systemd.user.units = mkOption {
      description = "Definition of systemd per-user units.";
      default = {};
      type = types.attrsOf types.optionSet;
      options = { name, config, ... }:
        { options = concreteUnitOptions;
          config = {
            unit = mkDefault (makeUnit name config);
          };
        };
    };

    systemd.user.services = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ serviceOptions unitConfig serviceConfig ];
      description = "Definition of systemd per-user service units.";
    };

    systemd.user.timers = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ timerOptions unitConfig ];
      description = "Definition of systemd per-user timer units.";
    };

    systemd.user.sockets = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ socketOptions unitConfig ];
      description = "Definition of systemd per-user socket units.";
    };

    systemd.additionalUpstreamSystemUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [ "debug-shell.service" "systemd-quotacheck.service" ];
      description = ''
        Additional units shipped with systemd that shall be enabled.
      '';
    };

  };


  ###### implementation

  config = {

    warnings = concatLists (mapAttrsToList (name: service:
      optional (service.serviceConfig.Type or "" == "oneshot" && service.serviceConfig.Restart or "no" != "no")
        "Service ‘${name}.service’ with ‘Type=oneshot’ must have ‘Restart=no’") cfg.services);

    system.build.units = cfg.units;

    environment.systemPackages = [ systemd ];

    environment.etc = let
      # generate contents for /etc/systemd/system-generators from
      # systemd.generators and systemd.generator-packages
      generators = pkgs.runCommand "system-generators" { packages = cfg.generator-packages; } ''
        mkdir -p $out
        for package in $packages
        do
          ln -s $package/lib/systemd/system-generators/* $out/
        done;
        ${concatStrings (mapAttrsToList (generator: target: "ln -s ${target} $out/${generator};\n") cfg.generators)}
      '';
    in ({
      "systemd/system".source = generateUnits "system" cfg.units upstreamSystemUnits upstreamSystemWants;

      "systemd/user".source = generateUnits "user" cfg.user.units upstreamUserUnits [];

      "systemd/system.conf".text = ''
        [Manager]
        ${config.systemd.extraConfig}
      '';

      "systemd/journald.conf".text = ''
        [Journal]
        RateLimitInterval=${config.services.journald.rateLimitInterval}
        RateLimitBurst=${toString config.services.journald.rateLimitBurst}
        ${optionalString (config.services.journald.console != "") ''
          ForwardToConsole=yes
          TTYPath=${config.services.journald.console}
        ''}
        ${config.services.journald.extraConfig}
      '';

      "systemd/logind.conf".text = ''
        [Login]
        ${config.services.logind.extraConfig}
      '';

      "systemd/sleep.conf".text = ''
        [Sleep]
      '';

      "tmpfiles.d/systemd.conf".source = "${systemd}/example/tmpfiles.d/systemd.conf";
      "tmpfiles.d/x11.conf".source = "${systemd}/example/tmpfiles.d/x11.conf";

      "tmpfiles.d/nixos.conf".text = ''
        # This file is created automatically and should not be modified.
        # Please change the option ‘systemd.tmpfiles.rules’ instead.

        ${concatStringsSep "\n" cfg.tmpfiles.rules}
      '';

      "systemd/system-generators" = { source = generators; };
    });

    system.activationScripts.systemd = stringAfter [ "groups" ]
      ''
        mkdir -m 0755 -p /var/lib/udev

        if ! [ -e /etc/machine-id ]; then
          ${systemd}/bin/systemd-machine-id-setup
        fi

        # Keep a persistent journal. Note that systemd-tmpfiles will
        # set proper ownership/permissions.
        mkdir -m 0700 -p /var/log/journal
      '';

    users.extraUsers.systemd-network.uid = config.ids.uids.systemd-network;
    users.extraGroups.systemd-network.gid = config.ids.gids.systemd-network;
    users.extraUsers.systemd-resolve.uid = config.ids.uids.systemd-resolve;
    users.extraGroups.systemd-resolve.gid = config.ids.gids.systemd-resolve;

    # Target for ‘charon send-keys’ to hook into.
    users.extraGroups.keys.gid = config.ids.gids.keys;

    systemd.targets.keys =
      { description = "Security Keys";
        unitConfig.X-StopOnReconfiguration = true;
      };

    systemd.targets.network-online.after = [ "ip-up.target" ];

    systemd.targets.network-pre = {
      wantedBy = [ "network.target" ];
      before = [ "network.target" ];
    };

    systemd.targets.remote-fs-pre = {
      wantedBy = [ "remote-fs.target" ];
      before = [ "remote-fs.target" ];
    };

    systemd.units =
      mapAttrs' (n: v: nameValuePair "${n}.target" (targetToUnit n v)) cfg.targets
      // mapAttrs' (n: v: nameValuePair "${n}.service" (serviceToUnit n v)) cfg.services
      // mapAttrs' (n: v: nameValuePair "${n}.socket" (socketToUnit n v)) cfg.sockets
      // mapAttrs' (n: v: nameValuePair "${n}.timer" (timerToUnit n v)) cfg.timers
      // mapAttrs' (n: v: nameValuePair "${n}.path" (pathToUnit n v)) cfg.paths
      // listToAttrs (map
                   (v: let n = escapeSystemdPath v.where;
                       in nameValuePair "${n}.mount" (mountToUnit n v)) cfg.mounts)
      // listToAttrs (map
                   (v: let n = escapeSystemdPath v.where;
                       in nameValuePair "${n}.automount" (automountToUnit n v)) cfg.automounts);

    systemd.user.units =
         mapAttrs' (n: v: nameValuePair "${n}.service" (serviceToUnit n v)) cfg.user.services
      // mapAttrs' (n: v: nameValuePair "${n}.socket"  (socketToUnit  n v)) cfg.user.sockets
      // mapAttrs' (n: v: nameValuePair "${n}.timer"   (timerToUnit   n v)) cfg.user.timers;

    system.requiredKernelConfig = map config.lib.kernelConfig.isEnabled
      [ "DEVTMPFS" "CGROUPS" "INOTIFY_USER" "SIGNALFD" "TIMERFD" "EPOLL" "NET"
        "SYSFS" "PROC_FS" "FHANDLE" "DMIID" "AUTOFS4_FS" "TMPFS_POSIX_ACL"
        "TMPFS_XATTR" "SECCOMP"
      ];

    environment.shellAliases =
      { start = "systemctl start";
        stop = "systemctl stop";
        restart = "systemctl restart";
        status = "systemctl status";
      };

    users.extraGroups.systemd-journal.gid = config.ids.gids.systemd-journal;
    users.extraUsers.systemd-journal-gateway.uid = config.ids.uids.systemd-journal-gateway;
    users.extraGroups.systemd-journal-gateway.gid = config.ids.gids.systemd-journal-gateway;

    # Generate timer units for all services that have a ‘startAt’ value.
    systemd.timers =
      mapAttrs (name: service:
        { wantedBy = [ "timers.target" ];
          timerConfig.OnCalendar = service.startAt;
        })
        (filterAttrs (name: service: service.startAt != "") cfg.services);

    # Generate timer units for all services that have a ‘startAt’ value.
    systemd.user.timers =
      mapAttrs (name: service:
        { wantedBy = [ "timers.target" ];
          timerConfig.OnCalendar = service.startAt;
        })
        (filterAttrs (name: service: service.startAt != "") cfg.user.services);

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
    systemd.services."systemd-rfkill@".restartIfChanged = false;
    systemd.services."user@".restartIfChanged = false;
    systemd.services.systemd-journal-flush.restartIfChanged = false;
    systemd.services.systemd-random-seed.restartIfChanged = false;
    systemd.services.systemd-remount-fs.restartIfChanged = false;
    systemd.services.systemd-update-utmp.restartIfChanged = false;
    systemd.services.systemd-user-sessions.restartIfChanged = false; # Restart kills all active sessions.
    systemd.targets.local-fs.unitConfig.X-StopOnReconfiguration = true;
    systemd.targets.remote-fs.unitConfig.X-StopOnReconfiguration = true;
    systemd.services.systemd-binfmt.wants = [ "proc-sys-fs-binfmt_misc.automount" ];

    # Don't bother with certain units in containers.
    systemd.services.systemd-remount-fs.unitConfig.ConditionVirtualization = "!container";
    systemd.services.systemd-random-seed.unitConfig.ConditionVirtualization = "!container";

  };

  # FIXME: Remove these eventually.
  imports =
    [ (mkRenamedOptionModule [ "boot" "systemd" "sockets" ] [ "systemd" "sockets" ])
      (mkRenamedOptionModule [ "boot" "systemd" "targets" ] [ "systemd" "targets" ])
      (mkRenamedOptionModule [ "boot" "systemd" "services" ] [ "systemd" "services" ])
    ];

}
