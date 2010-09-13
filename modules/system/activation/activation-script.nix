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
        script = pkgs.writeScript "nixos-activation-script"
          ''
            #! ${pkgs.stdenv.shell}

            export PATH=/empty
            for i in ${toString path}; do
                PATH=$PATH:$i/bin:$i/sbin;
            done
            
            ${
              let
                set' = mapAttrs (n: v: if builtins.isString v then noDepEntry v else v) set;
                withHeadlines = addAttributeName set';
              in textClosureMap id (withHeadlines) (attrNames withHeadlines)
            }

            # Make this configuration the current configuration.
            # The readlink is there to ensure that when $systemConfig = /system
            # (which is a symlink to the store), /var/run/current-system is still
            # used as a garbage collection root.
            ln -sfn "$(readlink -f "$systemConfig")" /var/run/current-system

            # Prevent the current configuration from being garbage-collected.
            ln -sfn /var/run/current-system /nix/var/nix/gcroots/current-system
          '';
      };
      
    };
    
  };

  
  ###### implementation

  config = {

    system.activationScripts.systemConfig =
      ''
        systemConfig="$1"
        if test -z "$systemConfig"; then
          systemConfig="/system" # for the installation CD
        fi
      '';

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

        mkdir -m 0755 -p /var/log
        mkdir -m 0755 -p /var/log/upstart

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
        mkdir -p /media
      '';
    
  };
  
}
