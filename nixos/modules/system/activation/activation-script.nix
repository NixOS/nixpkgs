# generate the script used to activate the configuration.
{ config, pkgs, ... }:

with pkgs.lib;

let

  addAttributeName = mapAttrs (a: v: v // {
    text = ''
      #### Activation script snippet ${a}:
      ${v.text}
    '';
  });

  path =
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

      example = {
        stdio = {
          text = ''
            # Needed by some programs.
            ln -sfn /proc/self/fd /dev/fd
            ln -sfn /proc/self/fd/0 /dev/stdin
            ln -sfn /proc/self/fd/1 /dev/stdout
            ln -sfn /proc/self/fd/2 /dev/stderr
          '';
          deps = [];
        };
      };

      description = ''
        Activate the new configuration (i.e., update /etc, make accounts,
        and so on).
      '';

      merge = mergeTypedOption "script" builtins.isAttrs (fold mergeAttrs {});

      apply = set: {
        script =
          ''
            #! ${pkgs.stdenv.shell}

            systemConfig=@out@

            export PATH=/empty
            for i in ${toString path}; do
                PATH=$PATH:$i/bin:$i/sbin
            done

            # Ensure a consistent umask.
            umask 0022

            ${
              let
                set' = mapAttrs (n: v: if builtins.isString v then noDepEntry v else v) set;
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
          '';
      };

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

        touch /var/run/utmp # must exist
        chgrp ${toString config.ids.gids.utmp} /var/run/utmp
        chmod 664 /var/run/utmp

        mkdir -m 0755 -p /var/run/nix/current-load # for distributed builds
        mkdir -m 0700 -p /var/run/nix/remote-stores

        # Directory holding symlinks to currently running Upstart
        # jobs.  Used to determine which jobs need to be restarted
        # when switching to a new configuration.
        mkdir -m 0700 -p /var/run/upstart-jobs

        mkdir -m 0755 -p /var/log

        touch /var/log/wtmp # must exist
        chmod 644 /var/log/wtmp

        touch /var/log/lastlog
        chmod 644 /var/log/lastlog

        mkdir -m 1777 -p /var/tmp

        # Empty, read-only home directory of many system accounts.
        mkdir -m 0555 -p /var/empty
      '';

    system.activationScripts.media =
      ''
        mkdir -m 0755 -p /media
      '';

    system.activationScripts.usrbinenv =
      ''
        mkdir -m 0755 -p /usr/bin
        ln -sfn ${pkgs.coreutils}/bin/env /usr/bin/.env.tmp
        mv /usr/bin/.env.tmp /usr/bin/env # atomically replace /usr/bin/env
      '';

    system.activationScripts.tmpfs =
      ''
        ${pkgs.utillinux}/bin/mount -o "remount,size=${config.boot.devSize}" none /dev
        ${pkgs.utillinux}/bin/mount -o "remount,size=${config.boot.devShmSize}" none /dev/shm
        ${pkgs.utillinux}/bin/mount -o "remount,size=${config.boot.runSize}" none /run
      '';

  };

}
