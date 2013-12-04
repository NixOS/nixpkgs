{ config, pkgs, utils, ... }:

with pkgs.lib;
with utils;
with import ./systemd-unit-options.nix { inherit config pkgs; };

let

  cfg = config.systemd;

  systemd = cfg.package;

  makeUnit = name: unit:
    pkgs.runCommand "unit" { inherit (unit) text; preferLocalBuild = true; }
      (if unit.enable then  ''
        mkdir -p $out
        echo -n "$text" > $out/${name}
      '' else ''
        mkdir -p $out
        ln -s /dev/null $out/${name}
      '');

  upstreamUnits =
    [ # Targets.
      "basic.target"
      "sysinit.target"
      "sockets.target"
      "graphical.target"
      "multi-user.target"
      "getty.target"
      "network.target"
      "network-online.target"
      "nss-lookup.target"
      "nss-user-lookup.target"
      "time-sync.target"
      #"cryptsetup.target"
      "sigpwr.target"
      "timers.target"
      "paths.target"

      # Rescue mode.
      "rescue.target"
      "rescue.service"

      # Udev.
      "systemd-udevd-control.socket"
      "systemd-udevd-kernel.socket"
      "systemd-udevd.service"
      "systemd-udev-settle.service"
      "systemd-udev-trigger.service"

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
      "user@.service"

      # Journal.
      "systemd-journald.socket"
      "systemd-journald.service"
      "systemd-journal-flush.service"
      "syslog.socket"

      # SysV init compatibility.
      "systemd-initctl.socket"
      "systemd-initctl.service"

      # Kernel module loading.
      #"systemd-modules-load.service"

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
      "sys-fs-fuse-connections.mount"
      "sys-kernel-config.mount"
      "sys-kernel-debug.mount"

      # Hibernate / suspend.
      "hibernate.target"
      "suspend.target"
      "sleep.target"
      "hybrid-sleep.target"
      "systemd-hibernate.service"
      "systemd-suspend.service"
      "systemd-hybrid-sleep.service"
      "systemd-shutdownd.socket"
      "systemd-shutdownd.service"

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

      # Password entry.
      "systemd-ask-password-console.path"
      "systemd-ask-password-console.service"
      "systemd-ask-password-wall.path"
      "systemd-ask-password-wall.service"
    ]

    ++ optionals cfg.enableEmergencyMode [
      "emergency.target"
      "emergency.service"
    ];

  upstreamWants =
    [ #"basic.target.wants"
      "sysinit.target.wants"
      "sockets.target.wants"
      "local-fs.target.wants"
      "multi-user.target.wants"
      "shutdown.target.wants"
      "timers.target.wants"
    ];

  makeJobScript = name: text:
    let x = pkgs.writeTextFile { name = "unit-script"; executable = true; destination = "/bin/${name}"; inherit text; };
    in "${x}/bin/${name}";

  unitConfig = { name, config, ... }: {
    config = {
      unitConfig =
        { Requires = concatStringsSep " " config.requires;
          Wants = concatStringsSep " " config.wants;
          After = concatStringsSep " " config.after;
          Before = concatStringsSep " " config.before;
          BindsTo = concatStringsSep " " config.bindsTo;
          PartOf = concatStringsSep " " config.partOf;
          Conflicts = concatStringsSep " " config.conflicts;
          "X-Restart-Triggers" = toString config.restartTriggers;
        } // optionalAttrs (config.description != "") {
          Description = config.description;
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

  toOption = x:
    if x == true then "true"
    else if x == false then "false"
    else toString x;

  attrsToSection = as:
    concatStrings (concatLists (mapAttrsToList (name: value:
      map (x: ''
          ${name}=${toOption x}
        '')
        (if isList value then value else [value]))
        as));

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
      text =
        ''
          [Unit]
          ${attrsToSection def.unitConfig}

          [Service]
          ${let env = cfg.globalEnvironment // def.environment;
            in concatMapStrings (n: "Environment=\"${n}=${getAttr n env}\"\n") (attrNames env)}
          ${optionalString (!def.restartIfChanged) "X-RestartIfChanged=false"}
          ${optionalString (!def.stopIfChanged) "X-StopIfChanged=false"}
          ${attrsToSection def.serviceConfig}
        '';
    };

  socketToUnit = name: def:
    { inherit (def) wantedBy requiredBy enable;
      text =
        ''
          [Unit]
          ${attrsToSection def.unitConfig}

          [Socket]
          ${attrsToSection def.socketConfig}
          ${concatStringsSep "\n" (map (s: "ListenStream=${s}") def.listenStreams)}
        '';
    };

  timerToUnit = name: def:
    { inherit (def) wantedBy requiredBy enable;
      text =
        ''
          [Unit]
          ${attrsToSection def.unitConfig}

          [Timer]
          ${attrsToSection def.timerConfig}
        '';
    };

  mountToUnit = name: def:
    { inherit (def) wantedBy requiredBy enable;
      text =
        ''
          [Unit]
          ${attrsToSection def.unitConfig}

          [Mount]
          ${attrsToSection def.mountConfig}
        '';
    };

  automountToUnit = name: def:
    { inherit (def) wantedBy requiredBy enable;
      text =
        ''
          [Unit]
          ${attrsToSection def.unitConfig}

          [Automount]
          ${attrsToSection def.automountConfig}
        '';
    };

  units = pkgs.runCommand "units" { preferLocalBuild = true; }
    ''
      mkdir -p $out
      for i in ${toString upstreamUnits}; do
        fn=${systemd}/example/systemd/system/$i
        if ! [ -e $fn ]; then echo "missing $fn"; false; fi
        if [ -L $fn ]; then
          cp -pd $fn $out/
        else
          ln -s $fn $out/
        fi
      done

      for i in ${toString upstreamWants}; do
        fn=${systemd}/example/systemd/system/$i
        if ! [ -e $fn ]; then echo "missing $fn"; false; fi
        x=$out/$(basename $fn)
        mkdir $x
        for i in $fn/*; do
          y=$x/$(basename $i)
          cp -pd $i $y
          if ! [ -e $y ]; then rm -v $y; fi
        done
      done

      for i in ${toString (mapAttrsToList (n: v: v.unit) cfg.units)}; do
        ln -s $i/* $out/
      done

      for i in ${toString cfg.packages}; do
        ln -s $i/etc/systemd/system/* $out/
      done

      ${concatStrings (mapAttrsToList (name: unit:
          concatMapStrings (name2: ''
            mkdir -p $out/'${name2}.wants'
            ln -sfn '../${name}' $out/'${name2}.wants'/
          '') unit.wantedBy) cfg.units)}

      ${concatStrings (mapAttrsToList (name: unit:
          concatMapStrings (name2: ''
            mkdir -p $out/'${name2}.requires'
            ln -sfn '../${name}' $out/'${name2}.requires'/
          '') unit.requiredBy) cfg.units)}

      ln -s ${cfg.defaultUnit} $out/default.target

      ln -s rescue.target $out/kbrequest.target

      mkdir -p $out/getty.target.wants/
      ln -s ../getty@tty1.service $out/getty.target.wants/

      ln -s ../local-fs.target ../remote-fs.target ../network.target ../nss-lookup.target \
            ../nss-user-lookup.target ../swap.target $out/multi-user.target.wants/
    ''; # */

in

{

  ###### interface

  options = {

    systemd.package = mkOption {
      default = pkgs.systemd;
      type = types.package;
      description = "The systemd package.";
    };

    systemd.units = mkOption {
      description = "Definition of systemd units.";
      default = {};
      type = types.attrsOf types.optionSet;
      options = { name, config, ... }:
        { options = {
            text = mkOption {
              type = types.str;
              description = "Text of this systemd unit.";
            };
            enable = mkOption {
              default = true;
              type = types.bool;
              description = ''
                If set to false, this unit will be a symlink to
                /dev/null. This is primarily useful to prevent specific
                template instances (e.g. <literal>serial-getty@ttyS0</literal>)
                from being started.
              '';
            };
            requiredBy = mkOption {
              default = [];
              type = types.listOf types.string;
              description = "Units that require (i.e. depend on and need to go down with) this unit.";
            };
            wantedBy = mkOption {
              default = [];
              type = types.listOf types.string;
              description = "Units that want (i.e. depend on) this unit.";
            };
            unit = mkOption {
              internal = true;
              description = "The generated unit.";
            };
          };
          config = {
            unit = makeUnit name config;
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
      options = [ unitOptions unitConfig ];
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
      type = types.uniq types.int;
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

    services.logind.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "HandleLidSwitch=ignore";
      description = ''
        Extra config options for systemd-logind. See man logind.conf for
        available options.
      '';
    };

    systemd.enableEmergencyMode = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable emergency mode, which is an
        <command>sulogin</command> shell started on the console if
        mounting a filesystem fails.  Since some machines (like EC2
        instances) have no console of any kind, emergency mode doesn't
        make sense, and it's better to continue with the boot insofar
        as possible.
      '';
    };

  };


  ###### implementation

  config = {

    system.build.units = units;

    environment.systemPackages = [ systemd ];

    environment.etc."systemd/system".source = units;

    environment.etc."systemd/system.conf".text =
      ''
        [Manager]
        ${config.systemd.extraConfig}
      '';

    environment.etc."systemd/journald.conf".text =
      ''
        [Journal]
        RateLimitInterval=${config.services.journald.rateLimitInterval}
        RateLimitBurst=${toString config.services.journald.rateLimitBurst}
        ${optionalString (config.services.journald.console != "") ''
          ForwardToConsole=yes
          TTYPath=${config.services.journald.console}
        ''}
        ${config.services.journald.extraConfig}
      '';

    environment.etc."systemd/logind.conf".text =
      ''
        [Login]
        ${config.services.logind.extraConfig}
      '';

    environment.etc."systemd/sleep.conf".text =
      ''
        [Sleep]
      '';

    system.activationScripts.systemd = stringAfter [ "groups" ]
      ''
        mkdir -m 0755 -p /var/lib/udev
        mkdir -p /var/log/journal
        chmod 0755 /var/log/journal

        # Make all journals readable to users in the wheel and adm
        # groups, in addition to those in the systemd-journal group.
        # Users can always read their own journals.
        ${pkgs.acl}/bin/setfacl -nm g:wheel:rx,d:g:wheel:rx,g:adm:rx,d:g:adm:rx /var/log/journal
      '';

    # Target for ‘charon send-keys’ to hook into.
    systemd.targets.keys =
      { description = "Security Keys";
      };

    systemd.units =
      mapAttrs' (n: v: nameValuePair "${n}.target" (targetToUnit n v)) cfg.targets
      // mapAttrs' (n: v: nameValuePair "${n}.service" (serviceToUnit n v)) cfg.services
      // mapAttrs' (n: v: nameValuePair "${n}.socket" (socketToUnit n v)) cfg.sockets
      // mapAttrs' (n: v: nameValuePair "${n}.timer" (timerToUnit n v)) cfg.timers
      // listToAttrs (map
                   (v: let n = escapeSystemdPath v.where;
                       in nameValuePair "${n}.mount" (mountToUnit n v)) cfg.mounts)
      // listToAttrs (map
                   (v: let n = escapeSystemdPath v.where;
                       in nameValuePair "${n}.automount" (automountToUnit n v)) cfg.automounts);

    system.requiredKernelConfig = map config.lib.kernelConfig.isEnabled [
      "CGROUPS" "AUTOFS4_FS" "DEVTMPFS"
    ];

    environment.shellAliases =
      { start = "systemctl start";
        stop = "systemctl stop";
        restart = "systemctl restart";
        status = "systemctl status";
      };

    users.extraGroups.systemd-journal.gid = config.ids.gids.systemd-journal;

    # Generate timer units for all services that have a ‘startAt’ value.
    systemd.timers =
      mapAttrs (name: service:
        { wantedBy = [ "timers.target" ];
          timerConfig.OnCalendar = service.startAt;
        })
        (filterAttrs (name: service: service.startAt != "") cfg.services);

    # FIXME: These are borrowed from upstream systemd.
    systemd.services."systemd-update-utmp" =
      { description = "Update UTMP about System Reboot/Shutdown";
        wantedBy = [ "sysinit.target" ];
        after = [ "systemd-remount-fs.service" ];
        before = [ "sysinit.target" "shutdown.target" ];
        conflicts = [ "shutdown.target" ];
        unitConfig = {
          DefaultDependencies = false;
          RequiresMountsFor = "/var/log";
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${systemd}/lib/systemd/systemd-update-utmp reboot";
          ExecStop = "${systemd}/lib/systemd/systemd-update-utmp shutdown";
        };
        restartIfChanged = false;
      };

    systemd.services."systemd-random-seed" =
      { description = "Load/Save Random Seed";
        wantedBy = [ "sysinit.target" "multi-user.target" ];
        after = [ "systemd-remount-fs.service" ];
        before = [ "sysinit.target" "shutdown.target" ];
        conflicts = [ "shutdown.target" ];
        unitConfig = {
          DefaultDependencies = false;
          RequiresMountsFor = "/var/lib";
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${systemd}/lib/systemd/systemd-random-seed load";
          ExecStop = "${systemd}/lib/systemd/systemd-random-seed save";
        };
      };

  };
}
