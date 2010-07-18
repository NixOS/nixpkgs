# generate the script used to activate the configuration.
{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mergeTypedOption mergeAttrs
    mapAttrs addErrorContext fold id filter textClosureMap noDepEntry
    fullDepEntry;
  inherit (builtins) attrNames;

  addAttributeName = mapAttrs (a: v: v // {
      text = ''
        #### actionScripts snippet ${a} :
        #    ========================================
        ${v.text}
      '';
    });

  defaultScripts = {
  
    systemConfig = noDepEntry ''
      systemConfig="$1"
      if test -z "$systemConfig"; then
        systemConfig="/system" # for the installation CD
      fi
    '';

    defaultPath =
      let path = [
        pkgs.coreutils pkgs.gnugrep pkgs.findutils
        pkgs.glibc # needed for getent
        pkgs.shadow
        pkgs.nettools # needed for hostname
      ]; in noDepEntry ''
        export PATH=/empty
        for i in ${toString path}; do
          PATH=$PATH:$i/bin:$i/sbin;
        done
      '';

    stdio = fullDepEntry ''
      # Needed by some programs.
      ln -sfn /proc/self/fd /dev/fd
      ln -sfn /proc/self/fd/0 /dev/stdin
      ln -sfn /proc/self/fd/1 /dev/stdout
      ln -sfn /proc/self/fd/2 /dev/stderr
    '' [
      "defaultPath" # path to ln
    ];

    binsh = fullDepEntry ''
      # Create the required /bin/sh symlink; otherwise lots of things
      # (notably the system() function) won't work.
      mkdir -m 0755 -p $mountPoint/bin
      ln -sfn ${config.system.build.binsh}/bin/sh $mountPoint/bin/sh
    '' [
      "defaultPath" # path to ln & mkdir
      "stdio" # ?
    ];

    modprobe = fullDepEntry ''
      # Allow the kernel to find our wrapped modprobe (which searches
      # in the right location in the Nix store for kernel modules).
      # We need this when the kernel (or some module) auto-loads a
      # module.
      echo ${config.system.sbin.modprobe}/sbin/modprobe > /proc/sys/kernel/modprobe
    '' [
      # ?
    ];

    var = fullDepEntry ''
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
    '' [
      "defaultPath" # path to mkdir & touch & chmod
    ];

    rootPasswd = fullDepEntry ''
      # If there is no password file yet, create a root account with an
      # empty password.
      if ! test -e /etc/passwd; then
          rootHome=/root
          touch /etc/passwd; chmod 0644 /etc/passwd
          touch /etc/group; chmod 0644 /etc/group
          touch /etc/shadow; chmod 0600 /etc/shadow
          # Can't use useradd, since it complains that it doesn't know us
          # (bootstrap problem!).
          echo "root:x:0:0:System administrator:$rootHome:${config.users.defaultUserShell}" >> /etc/passwd
          echo "root::::::::" >> /etc/shadow
      fi
    '' [
      "defaultPath" # path to touch & passwd
      "etc" # for /etc
      # ?
    ];

    nix = fullDepEntry ''
      # Set up Nix.
      mkdir -p /nix/etc/nix
      ln -sfn /etc/nix.conf /nix/etc/nix/nix.conf
      chown root.nixbld /nix/store
      chmod 1775 /nix/store

      # Nix initialisation.
      mkdir -m 0755 -p \
          /nix/var/nix/gcroots \
          /nix/var/nix/temproots \
          /nix/var/nix/manifests \
          /nix/var/nix/userpool \
          /nix/var/nix/profiles \
          /nix/var/nix/db \
          /nix/var/log/nix/drvs \
          /nix/var/nix/channel-cache \
          /nix/var/nix/chroots
      mkdir -m 1777 -p /nix/var/nix/gcroots/per-user
      mkdir -m 1777 -p /nix/var/nix/profiles/per-user

      ln -sf /nix/var/nix/profiles /nix/var/nix/gcroots/
      ln -sf /nix/var/nix/manifests /nix/var/nix/gcroots/
    '' [
      "defaultPath"
      "etc" # /etc/nix.conf
      "users" # nixbld group
    ];

    hostname = fullDepEntry ''
      # Set the host name.  Don't clear it if it's not configured in the
      # NixOS configuration, since it may have been set by dhclient in the
      # meantime.
      ${if config.networking.hostName != "" then
          ''hostname "${config.networking.hostName}"''
      else ''
          # dhclient won't do anything if the hostname isn't empty.
          if test "$(hostname)" = "(none)"; then
            hostname ""
          fi
      ''}
    '' [ "defaultPath" ];

    # The activation has to be done at the end. This is forced at the apply
    # function of activationScripts option
    activate = noDepEntry ''
      # Make this configuration the current configuration.
      # The readlink is there to ensure that when $systemConfig = /system
      # (which is a symlink to the store), /var/run/current-system is still
      # used as a garbage collection root.
      ln -sfn "$(readlink -f "$systemConfig")" /var/run/current-system

      # Prevent the current configuration from being garbage-collected.
      ln -sfn /var/run/current-system /nix/var/nix/gcroots/current-system
    '';

    media = noDepEntry ''
      mkdir -p /media
    '';
    
  };
  
    
in

{
  require = {
    system = {
      activationScripts = mkOption {
        default = [];
        example = {
          stdio = {
            text = "
              # Needed by some programs.
              ln -sfn /proc/self/fd /dev/fd
              ln -sfn /proc/self/fd/0 /dev/stdin
              ln -sfn /proc/self/fd/1 /dev/stdout
              ln -sfn /proc/self/fd/2 /dev/stderr
            ";
            deps = [];
          };
        };
        description = ''
          Activate the new configuration (i.e., update /etc, make accounts,
          and so on).
        '';
        merge = mergeTypedOption "script" builtins.isAttrs (fold mergeAttrs {});
        apply = set:
          let withHeadlines = addAttributeName set;
              activateLib = removeAttrs withHeadlines ["activate"];
              activateLibNames = attrNames activateLib;
          in {
          script = pkgs.writeScript "nixos-activation-script"
            ("#! ${pkgs.stdenv.shell}\n"
             + textClosureMap id activateLib activateLibNames + "\n"
               # make sure that the activate snippet is added last.
             + withHeadlines.activate.text);
        };
      };
    };
  };

  system.activationScripts = defaultScripts;
}
