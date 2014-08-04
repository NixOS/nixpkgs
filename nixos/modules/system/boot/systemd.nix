{ config, lib, pkgs, utils, ... }:

with lib;
with utils;
with import ./systemd-unit-options.nix { inherit config lib; };

let

  cfg = config.systemd;

  systemd = cfg.package;

  makeUnit = name: unit:
    if unit.enable then
      pkgs.runCommand "unit" { preferLocalBuild = true; inherit (unit) text; }
        ''
          mkdir -p $out
          echo -n "$text" > $out/${shellEscape name}
        ''
    else
      pkgs.runCommand "unit" { preferLocalBuild = true; }
        ''
          mkdir -p $out
          ln -s /dev/null $out/${shellEscape name}
        '';

  upstreamSystemUnits =
    [ # Targets.
      "basic.target"
      "sysinit.target"
      "sockets.target"
      "graphical.target"
      "multi-user.target"
      "network.target"
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
      "user@.service"

      # Journal.
      "systemd-journald.socket"
      "systemd-journald.service"
      "systemd-journal-flush.service"
      "systemd-journal-gatewayd.socket"
      "systemd-journal-gatewayd.service"
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
      "systemd-rfkill@.service"

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
      "systemd-sysctl.service"
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

  shellEscape = s: (replaceChars [ "\\" ] [ "\\\\" ] s);

  makeJobScript = name: text:
    let x = pkgs.writeTextFile { name = "unit-script"; executable = true; destination = "/bin/${shellEscape name}"; inherit text; };
    in "${x}/bin/${shellEscape name}";

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
        // optionalAttrs (config.restartTriggers != [])
          { X-Restart-Triggers = toString config.restartTriggers; }
        // optionalAttrs (config.description != "") {
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
              let s = "Environment=\"${n}=${getAttr n env}\"\n";
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

  generateUnits = type: units: upstreamUnits: upstreamWants:
    pkgs.runCommand "${type}-units" { preferLocalBuild = true; } ''
      mkdir -p $out

      # Copy the upstream systemd units we're interested in.
      for i in ${toString upstreamUnits}; do
        fn=${systemd}/example/systemd/${type}/$i
        if ! [ -e $fn ]; then echo "missing $fn"; false; fi
        if [ -L $fn ]; then
          target="$(readlink "$fn")"
          if [ ''${target:0:3} = ../ ]; then
            ln -s "$(readlink -f "$fn")" $out/
          else
            cp -pd $fn $out/
          fi
        else
          ln -s $fn $out/
        fi
      done

      # Copy .wants links, but only those that point to units that
      # we're interested in.
      for i in ${toString upstreamWants}; do
        fn=${systemd}/example/systemd/${type}/$i
        if ! [ -e $fn ]; then echo "missing $fn"; false; fi
        x=$out/$(basename $fn)
        mkdir $x
        for i in $fn/*; do
          y=$x/$(basename $i)
          cp -pd $i $y
          if ! [ -e $y ]; then rm $y; fi
        done
      done

      # Symlink all units provided listed in systemd.packages.
      for i in ${toString cfg.packages}; do
        for fn in $i/etc/systemd/${type}/* $i/lib/systemd/${type}/*; do
          if ! [[ "$fn" =~ .wants$ ]]; then
            ln -s $fn $out/
          fi
        done
      done

      # Symlink all units defined by systemd.units. If these are also
      # provided by systemd or systemd.packages, then add them as
      # <unit-name>.d/overrides.conf, which makes them extend the
      # upstream unit.
      for i in ${toString (mapAttrsToList (n: v: v.unit) units)}; do
        fn=$(basename $i/*)
        if [ -e $out/$fn ]; then
          if [ "$(readlink -f $i/$fn)" = /dev/null ]; then
            ln -sfn /dev/null $out/$fn
          else
            mkdir $out/$fn.d
            ln -s $i/$fn $out/$fn.d/overrides.conf
          fi
       else
          ln -fs $i/$fn $out/
        fi
      done

      # Created .wants and .requires symlinks from the wantedBy and
      # requiredBy options.
      ${concatStrings (mapAttrsToList (name: unit:
          concatMapStrings (name2: ''
            mkdir -p $out/'${name2}.wants'
            ln -sfn '../${name}' $out/'${name2}.wants'/
          '') unit.wantedBy) units)}

      ${concatStrings (mapAttrsToList (name: unit:
          concatMapStrings (name2: ''
            mkdir -p $out/'${name2}.requires'
            ln -sfn '../${name}' $out/'${name2}.requires'/
          '') unit.requiredBy) units)}

      ${optionalString (type == "system") ''
        # Stupid misc. symlinks.
        ln -s ${cfg.defaultUnit} $out/default.target

        ln -s rescue.target $out/kbrequest.target

        mkdir -p $out/getty.target.wants/
        ln -s ../autovt@tty1.service $out/getty.target.wants/

        ln -s ../local-fs.target ../remote-fs.target ../network.target ../nss-lookup.target \
              ../nss-user-lookup.target ../swap.target $out/multi-user.target.wants/
      ''}
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

    environment.etc."systemd/system".source =
      generateUnits "system" cfg.units upstreamSystemUnits upstreamSystemWants;

    environment.etc."systemd/user".source =
      generateUnits "user" cfg.user.units upstreamUserUnits [];

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
    users.extraGroups.keys.gid = config.ids.gids.keys;

    systemd.targets.keys =
      { description = "Security Keys";
        unitConfig.X-StopOnReconfiguration = true;
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
      // mapAttrs' (n: v: nameValuePair "${n}.socket" (socketToUnit n v)) cfg.user.sockets;

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

    systemd.sockets.systemd-journal-gatewayd.wantedBy =
      optional config.services.journald.enableHttpGateway "sockets.target";

    # Provide the systemd-user PAM service, required to run systemd
    # user instances.
    security.pam.services.systemd-user =
      { # Ensure that pam_systemd gets included. This is special-cased
        # in systemd to provide XDG_RUNTIME_DIR.
        startSession = true;
      };

    environment.etc."tmpfiles.d/x11.conf".source = "${systemd}/example/tmpfiles.d/x11.conf";

    environment.etc."tmpfiles.d/nixos.conf".text =
      ''
        # This file is created automatically and should not be modified.
        # Please change the option ‘systemd.tmpfiles.rules’ instead.
        ${concatStringsSep "\n" cfg.tmpfiles.rules}
      '';

    systemd.services."user@".restartIfChanged = false;

    systemd.services.systemd-remount-fs.restartIfChanged = false;
    systemd.services.systemd-journal-flush.restartIfChanged = false;

  };
}
