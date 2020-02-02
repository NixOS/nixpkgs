# generate the script used to activate the configuration.
{ config, lib, pkgs, ... }:

with lib;

let

  addAttributeName = mapAttrs (a: v: v // {
    text = ''
      #### Activation script snippet ${a}:
      _localstatus=0
      ${v.text}

      if (( _localstatus > 0 )); then
        printf "Activation script snippet '%s' failed (%s)\n" "${a}" "$_localstatus"
      fi
    '';
  });

  path = with pkgs; map getBin
    [ coreutils
      gnugrep
      findutils
      getent
      stdenv.cc.libc # nscd in update-users-groups.pl
      shadow
      nettools # needed for hostname
      utillinux # needed for mount and mountpoint
    ];

in

{

  ###### interface

  options = {

    system.activationScripts = mkOption {
      default = {};

      example = literalExample ''
        { stdio = {
            text = '''
              # Needed by some programs.
              ln -sfn /proc/self/fd /dev/fd
              ln -sfn /proc/self/fd/0 /dev/stdin
              ln -sfn /proc/self/fd/1 /dev/stdout
              ln -sfn /proc/self/fd/2 /dev/stderr
            ''';
            deps = [];
          };
        }
      '';

      description = ''
        A set of shell script fragments that are executed when a NixOS
        system configuration is activated.  Examples are updating
        /etc, creating accounts, and so on.  Since these are executed
        every time you boot the system or run
        <command>nixos-rebuild</command>, it's important that they are
        idempotent and fast.
      '';

      type = types.attrsOf types.unspecified; # FIXME

      apply = set: {
        script =
          ''
            #! ${pkgs.runtimeShell}

            systemConfig=@out@

            export PATH=/empty
            for i in ${toString path}; do
                PATH=$PATH:$i/bin:$i/sbin
            done

            _status=0
            trap "_status=1 _localstatus=\$?" ERR

            # Ensure a consistent umask.
            umask 0022

            ${
              let
                set' = mapAttrs (n: v: if isString v then noDepEntry v else v) set;
                withHeadlines = addAttributeName set';
              in textClosureMap id (withHeadlines) (attrNames withHeadlines)
            }

            # Make this configuration the current configuration.
            # The readlink is there to ensure that when $systemConfig = /system
            # (which is a symlink to the store), /run/current-system is still
            # used as a garbage collection root.
            ln -sfn "$(readlink -f "$systemConfig")" /run/current-system

            # Prevent the current configuration from being garbage-collected.
            ln -sfn /run/current-system /nix/var/nix/gcroots/current-system

            exit $_status
          '';
      };
    };

    system.userActivationScripts = mkOption {
      default = {};

      example = literalExample ''
        { plasmaSetup = {
            text = '''
              ${pkgs.libsForQt5.kservice}/bin/kbuildsycoca5"
            ''';
            deps = [];
          };
        }
      '';

      description = ''
        A set of shell script fragments that are executed by a systemd user
        service when a NixOS system configuration is activated. Examples are
        rebuilding the .desktop file cache for showing applications in the menu.
        Since these are executed every time you run
        <command>nixos-rebuild</command>, it's important that they are
        idempotent and fast.
      '';

      type = types.attrsOf types.unspecified;

      apply = set: {
        script = ''
          unset PATH
          for i in ${toString path}; do
            PATH=$PATH:$i/bin:$i/sbin
          done

          _status=0
          trap "_status=1 _localstatus=\$?" ERR

          ${
            let
              set' = mapAttrs (n: v: if isString v then noDepEntry v else v) set;
              withHeadlines = addAttributeName set';
            in textClosureMap id (withHeadlines) (attrNames withHeadlines)
          }

          exit $_status
        '';
      };

    };

    environment.usrbinenv = mkOption {
      default = "${pkgs.coreutils}/bin/env";
      example = literalExample ''
        "''${pkgs.busybox}/bin/env"
      '';
      type = types.nullOr types.path;
      visible = false;
      description = ''
        The env(1) executable that is linked system-wide to
        <literal>/usr/bin/env</literal>.
      '';
    };

    environment.ld-linux = mkOption {
      default = false;
      type = types.bool;
      visible = false;
      description = ''
        Install symlink to ld-linux(8) system-wide to allow running unmodified ELF binaries.
        It might be useful to run games or executables distributed inside jar files.
      '';
    };
  };


  ###### implementation

  config = {

    system.activationScripts.stdio = ""; # obsolete

    system.activationScripts.var =
      ''
        # Various log/runtime directories.

        mkdir -m 1777 -p /var/tmp

        # Empty, immutable home directory of many system accounts.
        mkdir -p /var/empty
        # Make sure it's really empty
        ${pkgs.e2fsprogs}/bin/chattr -f -i /var/empty || true
        find /var/empty -mindepth 1 -delete
        chmod 0555 /var/empty
        chown root:root /var/empty
        ${pkgs.e2fsprogs}/bin/chattr -f +i /var/empty || true
      '';

    system.activationScripts.usrbinenv = if config.environment.usrbinenv != null
      then ''
        mkdir -m 0755 -p /usr/bin
        ln -sfn ${config.environment.usrbinenv} /usr/bin/.env.tmp
        mv /usr/bin/.env.tmp /usr/bin/env # atomically replace /usr/bin/env
      ''
      else ''
        rm -f /usr/bin/env
        rmdir -p /usr/bin || true
      '';

    system.activationScripts.ld-linux =
      concatStrings (
        mapAttrsToList
          (target: source:
            if config.environment.ld-linux then ''
              mkdir -m 0755 -p $(dirname ${target})
              ln -sfn ${escapeShellArg source} ${target}.tmp
              mv -f ${target}.tmp ${target} # atomically replace
            '' else ''
              rm -f ${target}
              rmdir $(dirname ${target}) || true
            '')
          {
            "i686-linux"   ."/lib/ld-linux.so.2"          = "${pkgs.glibc.out}/lib/ld-linux.so.2";
            "x86_64-linux" ."/lib/ld-linux.so.2"          = "${pkgs.pkgsi686Linux.glibc.out}/lib/ld-linux.so.2";
            "x86_64-linux" ."/lib64/ld-linux-x86-64.so.2" = "${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2";
            "aarch64-linux"."/lib/ld-linux-aarch64.so.1"  = "${pkgs.glibc.out}/lib/ld-linux-aarch64.so.1";
            "armv7l-linux" ."/lib/ld-linux-armhf.so.3"    = "${pkgs.glibc.out}/lib/ld-linux-armhf.so.3";
          }.${pkgs.stdenv.system} or {}
      );

    system.activationScripts.specialfs =
      ''
        specialMount() {
          local device="$1"
          local mountPoint="$2"
          local options="$3"
          local fsType="$4"

          if mountpoint -q "$mountPoint"; then
            local options="remount,$options"
          else
            mkdir -m 0755 -p "$mountPoint"
          fi
          mount -t "$fsType" -o "$options" "$device" "$mountPoint"
        }
        source ${config.system.build.earlyMountScript}
      '';

    systemd.user = {
      services.nixos-activation = {
        description = "Run user-specific NixOS activation";
        script = config.system.userActivationScripts.script;
        unitConfig.ConditionUser = "!@system";
        serviceConfig.Type = "oneshot";
      };
    };
  };

}
