# generate the script used to activate the configuration.
{ config, lib, pkgs, ... }:

with lib;

let

  addAttributeName = mapAttrs (a: v: v // {
    text = ''
      #### Activation script snippet ${a}:
      ${v.text}
    '';
  });

  path = map # outputs TODO?
    (pkg: (pkg.bin or (pkg.out or pkg)))
    [ pkgs.coreutils pkgs.gnugrep pkgs.findutils
      pkgs.glibc # needed for getent
      pkgs.shadow
      pkgs.nettools # needed for hostname
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
            #! ${pkgs.stdenv.shell}

            systemConfig=@out@

            export PATH=/empty
            for i in ${toString path}; do
                PATH=$PATH:$i/bin:$i/sbin
            done

            _status=0
            trap "_status=1" ERR

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
  };


  ###### implementation

  config = {

    system.activationScripts.stdio =
      ''
        # Needed by some programs.
        ln -sfn /proc/self/fd /dev/fd
        ln -sfn /proc/self/fd/0 /dev/stdin
        ln -sfn /proc/self/fd/1 /dev/stdout
        ln -sfn /proc/self/fd/2 /dev/stderr
      '';

    system.activationScripts.var =
      ''
        # Various log/runtime directories.

        mkdir -m 0755 -p /run/nix/current-load # for distributed builds
        mkdir -m 0700 -p /run/nix/remote-stores

        mkdir -m 0755 -p /var/log

        touch /var/log/wtmp /var/log/lastlog # must exist
        chmod 644 /var/log/wtmp /var/log/lastlog

        mkdir -m 1777 -p /var/tmp

        # Empty, read-only home directory of many system accounts.
        mkdir -m 0555 -p /var/empty
      '';

    system.activationScripts.usrbinenv = if config.environment.usrbinenv != null
      then ''
        mkdir -m 0755 -p /usr/bin
        ln -sfn ${config.environment.usrbinenv} /usr/bin/.env.tmp
        mv /usr/bin/.env.tmp /usr/bin/env # atomically replace /usr/bin/env
      ''
      else ''
        rm -f /usr/bin/env
        rmdir --ignore-fail-on-non-empty /usr/bin /usr
      '';

    system.activationScripts.tmpfs =
      ''
        ${pkgs.utillinux}/bin/mount -o "remount,size=${config.boot.devSize}" none /dev
        ${pkgs.utillinux}/bin/mount -o "remount,size=${config.boot.devShmSize}" none /dev/shm
        ${pkgs.utillinux}/bin/mount -o "remount,size=${config.boot.runSize}" none /run
      '' + optionalString config.boot.tmpOnTmpfs ''
        if [ mountpoint -q /tmp ]; then
          ${pkgs.utillinux}/bin/mount -o "remount,size=${config.boot.tmpFsSize}" none /tmp
        fi
      '';
  };

}
