{ config, pkgs, ... }:

with pkgs.lib;
with import ./systemd-unit-options.nix { inherit config pkgs; };

let

  cfg = config.boot.systemd;

  systemd = pkgs.systemd;

  makeUnit = name: unit:
    pkgs.writeTextFile { name = "unit"; inherit (unit) text; destination = "/${name}"; };

  upstreamUnits =
    [ # Targets.
      "basic.target"
      "sysinit.target"
      "sockets.target"
      "graphical.target"
      "multi-user.target"
      "getty.target"
      "rescue.target"
      "network.target"
      "nss-lookup.target"
      "nss-user-lookup.target"
      "syslog.target"
      "time-sync.target"
      #"cryptsetup.target"
      "sigpwr.target"

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
      "systemd-vconsole-setup.service"
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
      "runlevel0.target"
      "runlevel1.target"
      "runlevel2.target"
      "runlevel3.target"
      "runlevel4.target"
      "runlevel5.target"
      "runlevel6.target"

      # Random seed.
      "systemd-random-seed-load.service"
      "systemd-random-seed-save.service"

      # Utmp maintenance.
      "systemd-update-utmp-runlevel.service"
      "systemd-update-utmp-shutdown.service"

      # Kernel module loading.
      "systemd-modules-load.service"

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
      "systemd-hibernate.service"
      "systemd-suspend.service"
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

      # Password entry.
      "systemd-ask-password-console.path"
      "systemd-ask-password-console.service"
      "systemd-ask-password-wall.path"
      "systemd-ask-password-wall.service"
    ];

  upstreamWants =
    [ "basic.target.wants"
      "sysinit.target.wants"
      "sockets.target.wants"
      "local-fs.target.wants"
      "multi-user.target.wants"
      "shutdown.target.wants"
    ];

  rescueService =
    ''
      [Unit]
      Description=Rescue Shell
      DefaultDependencies=no
      Conflicts=shutdown.target
      After=sysinit.target
      Before=shutdown.target

      [Service]
      Environment=HOME=/root
      WorkingDirectory=/root
      ExecStartPre=-${pkgs.coreutils}/bin/echo 'Welcome to rescue mode. Use "systemctl default" or ^D to enter default mode.'
      #ExecStart=-/sbin/sulogin
      ExecStart=-${pkgs.bashInteractive}/bin/bash --login
      ExecStopPost=-${systemd}/bin/systemctl --fail --no-block default
      Type=idle
      StandardInput=tty-force
      StandardOutput=inherit
      StandardError=inherit
      KillMode=process

      # Bash ignores SIGTERM, so we send SIGHUP instead, to ensure that bash
      # terminates cleanly.
      KillSignal=SIGHUP
    '';

  fsTarget =
    ''
      [Unit]
      Description=All File Systems
      Wants=local-fs.target remote-fs.target
    '';

  makeJobScript = name: content: "${pkgs.writeScriptBin name content}/bin/${name}";

  serviceConfig = { name, config, ... }: {
    config = {
      # Default path for systemd services.  Should be quite minimal.
      path =
        [ pkgs.coreutils
          pkgs.findutils
          pkgs.gnugrep
          pkgs.gnused
          systemd
        ];
    };
  };

  serviceToUnit = name: def:
    { inherit (def) wantedBy;

      text =
        ''
          [Unit]
          ${optionalString (def.description != "") ''
            Description=${def.description}
          ''}
          Requires=${concatStringsSep " " def.requires}
          Wants=${concatStringsSep " " def.wants}
          After=${concatStringsSep " " def.after}
          Before=${concatStringsSep " " def.before}
          PartOf=${concatStringsSep " " def.partOf}
          ${def.unitConfig}

          [Service]
          Environment=PATH=${def.path}
          ${concatMapStrings (n: "Environment=${n}=${getAttr n def.environment}\n") (attrNames def.environment)}
          ${optionalString (!def.restartIfChanged) "X-RestartIfChanged=false"}

          ${optionalString (def.preStart != "") ''
            ExecStartPre=${makeJobScript "${name}-prestart.sh" ''
              #! ${pkgs.stdenv.shell} -e
              ${def.preStart}
            ''}
          ''}

          ${optionalString (def.script != "") ''
            ExecStart=${makeJobScript "${name}.sh" ''
              #! ${pkgs.stdenv.shell} -e
              ${def.script}
            ''}
          ''}

          ${def.serviceConfig}
        '';
    };

  nixosUnits = mapAttrsToList makeUnit cfg.units;

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

      for i in ${toString nixosUnits}; do
        ln -s $i/* $out/
      done

      for i in ${toString cfg.packages}; do
        ln -s $i/etc/systemd/system/* $out/
      done

      ${concatStrings (mapAttrsToList (name: unit:
          concatMapStrings (name2: ''
            mkdir -p $out/${name2}.wants
            ln -sfn ../${name} $out/${name2}.wants/
          '') unit.wantedBy) cfg.units)}

      ln -s ${cfg.defaultUnit} $out/default.target

      #ln -s ../getty@tty1.service $out/multi-user.target.wants/
      ln -s ../remote-fs.target $out/multi-user.target.wants/
      ln -s ../network.target $out/multi-user.target.wants/
    ''; # */

in

{

  ###### interface

  options = {

    boot.systemd.units = mkOption {
      description = "Definition of systemd units.";
      default = {};
      type = types.attrsOf types.optionSet;
      options = {
        text = mkOption {
          types = types.uniq types.string;
          description = "Text of this systemd unit.";
        };
        wantedBy = mkOption {
          default = [];
          types = types.listOf types.string;
          description = "Units that want (i.e. depend on) this unit.";
        };
      };
    };

    boot.systemd.packages = mkOption {
      default = [];
      type = types.listOf types.package;
      description = "Packages providing systemd units.";
    };

    boot.systemd.services = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ serviceOptions serviceConfig ];
      description = "Definition of systemd services.";
    };

    boot.systemd.defaultUnit = mkOption {
      default = "multi-user.target";
      type = types.uniq types.string;
      description = "Default unit started when the system boots.";
    };

    services.journald.logKernelMessages = mkOption {
      default = true;
      type = types.bool;
      description = "Whether to log kernel messages.";
    };

    services.journald.console = mkOption {
      default = "";
      type = types.uniq types.string;
      description = "If non-empty, write log messages to the specified TTY device.  Defaults to /dev/console.";
    };

  };


  ###### implementation

  config = {

    system.build.systemd = systemd;

    system.build.units = units;

    environment.systemPackages = [ systemd ];

    environment.etc =
      [ { source = units;
          target = "systemd/system";
        }
        { source = pkgs.writeText "systemd.conf"
            ''
              [Manager]
              JoinControllers=cpu,cpuacct net_cls,netprio
            '';
          target = "systemd/system.conf";
        }
        { source = pkgs.writeText "journald.conf"
            ''
              [Journal]
              ${optionalString (config.services.journald.console != "") ''
                ForwardToConsole=yes
                TTYPath=${config.services.journald.console}
              ''}
              ${optionalString config.services.journald.logKernelMessages ''
                ImportKernel=yes
              ''}
            '';
          target = "systemd/journald.conf";
        }
      ];

    boot.systemd.units =
      { "rescue.service".text = rescueService; }
      // { "fs.target" = { text = fsTarget; wantedBy = [ "multi-user.target" ]; }; }
      // mapAttrs' (n: v: nameValuePair "${n}.service" (serviceToUnit n v)) cfg.services;

  };

}
