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

  systemActivationScript = set: onlyDry: let
    set' = mapAttrs (_: v: if isString v then (noDepEntry v) // { supportsDryActivation = false; } else v) set;
    withHeadlines = addAttributeName set';
    # When building a dry activation script, this replaces all activation scripts
    # that do not support dry mode with a comment that does nothing. Filtering these
    # activation scripts out so they don't get generated into the dry activation script
    # does not work because when an activation script that supports dry mode depends on
    # an activation script that does not, the dependency cannot be resolved and the eval
    # fails.
    withDrySnippets = mapAttrs (a: v: if onlyDry && !v.supportsDryActivation then v // {
      text = "#### Activation script snippet ${a} does not support dry activation.";
    } else v) withHeadlines;
  in
    ''
      #!${pkgs.runtimeShell}

      systemConfig='@out@'

      export PATH=/empty
      for i in ${toString path}; do
          PATH=$PATH:$i/bin:$i/sbin
      done

      _status=0
      trap "_status=1 _localstatus=\$?" ERR

      # Ensure a consistent umask.
      umask 0022

      ${textClosureMap id (withDrySnippets) (attrNames withDrySnippets)}

    '' + optionalString (!onlyDry) ''
      # Make this configuration the current configuration.
      # The readlink is there to ensure that when $systemConfig = /system
      # (which is a symlink to the store), /run/current-system is still
      # used as a garbage collection root.
      ln -sfn "$(readlink -f "$systemConfig")" /run/current-system

      exit $_status
    '';

  path = with pkgs; map getBin
    [ coreutils
      gnugrep
      findutils
      getent
      stdenv.cc.libc # nscd in update-users-groups.pl
      shadow
      nettools # needed for hostname
      util-linux # needed for mount and mountpoint
    ];

  scriptType = withDry: with types;
    let scriptOptions =
      { deps = mkOption
          { type = types.listOf types.str;
            default = [ ];
            description = lib.mdDoc "List of dependencies. The script will run after these.";
          };
        text = mkOption
          { type = types.lines;
            description = lib.mdDoc "The content of the script.";
          };
      } // optionalAttrs withDry {
        supportsDryActivation = mkOption
          { type = types.bool;
            default = false;
            description = lib.mdDoc ''
              Whether this activation script supports being dry-activated.
              These activation scripts will also be executed on dry-activate
              activations with the environment variable
              `NIXOS_ACTION` being set to `dry-activate`.
              it's important that these activation scripts  don't
              modify anything about the system when the variable is set.
            '';
          };
      };
    in either str (submodule { options = scriptOptions; });

in

{

  ###### interface

  options = {

    system.activationScripts = mkOption {
      default = {};

      example = literalExpression ''
        { stdio.text =
          '''
            # Needed by some programs.
            ln -sfn /proc/self/fd /dev/fd
            ln -sfn /proc/self/fd/0 /dev/stdin
            ln -sfn /proc/self/fd/1 /dev/stdout
            ln -sfn /proc/self/fd/2 /dev/stderr
          ''';
        }
      '';

      description = lib.mdDoc ''
        A set of shell script fragments that are executed when a NixOS
        system configuration is activated.  Examples are updating
        /etc, creating accounts, and so on.  Since these are executed
        every time you boot the system or run
        {command}`nixos-rebuild`, it's important that they are
        idempotent and fast.
      '';

      type = types.attrsOf (scriptType true);
      apply = set: set // {
        script = systemActivationScript set false;
      };
    };

    system.dryActivationScript = mkOption {
      description = lib.mdDoc "The shell script that is to be run when dry-activating a system.";
      readOnly = true;
      internal = true;
      default = systemActivationScript (removeAttrs config.system.activationScripts [ "script" ]) true;
      defaultText = literalMD "generated activation script";
    };

    system.userActivationScripts = mkOption {
      default = {};

      example = literalExpression ''
        { plasmaSetup = {
            text = '''
              ''${pkgs.libsForQt5.kservice}/bin/kbuildsycoca5"
            ''';
            deps = [];
          };
        }
      '';

      description = lib.mdDoc ''
        A set of shell script fragments that are executed by a systemd user
        service when a NixOS system configuration is activated. Examples are
        rebuilding the .desktop file cache for showing applications in the menu.
        Since these are executed every time you run
        {command}`nixos-rebuild`, it's important that they are
        idempotent and fast.
      '';

      type = with types; attrsOf (scriptType false);

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
      defaultText = literalExpression ''"''${pkgs.coreutils}/bin/env"'';
      example = literalExpression ''"''${pkgs.busybox}/bin/env"'';
      type = types.nullOr types.path;
      visible = false;
      description = lib.mdDoc ''
        The env(1) executable that is linked system-wide to
        `/usr/bin/env`.
      '';
    };

    system.build.installBootLoader = mkOption {
      internal = true;
      # "; true" => make the `$out` argument from switch-to-configuration.pl
      #             go to `true` instead of `echo`, hiding the useless path
      #             from the log.
      default = "echo 'Warning: do not know how to make this configuration bootable; please enable a boot loader.' 1>&2; true";
      description = lib.mdDoc ''
        A program that writes a bootloader installation script to the path passed in the first command line argument.

        See `nixos/modules/system/activation/switch-to-configuration.pl`.
      '';
      type = types.unique {
        message = ''
          Only one bootloader can be enabled at a time. This requirement has not
          been checked until NixOS 22.05. Earlier versions defaulted to the last
          definition. Change your configuration to enable only one bootloader.
        '';
      } (types.either types.str types.package);
    };

  };


  ###### implementation

  config = {

    system.activationScripts.stdio = ""; # obsolete
    system.activationScripts.var = ""; # obsolete

    systemd.tmpfiles.rules = [
      # Prevent the current configuration from being garbage-collected.
      "d /nix/var/nix/gcroots -"
      "L+ /nix/var/nix/gcroots/current-system - - - - /run/current-system"
      "D /var/empty 0555 root root -"
      "h /var/empty - - - - +i"
    ];

    system.activationScripts.usrbinenv = if config.environment.usrbinenv != null
      then ''
        mkdir -p /usr/bin
        chmod 0755 /usr/bin
        ln -sfn ${config.environment.usrbinenv} /usr/bin/.env.tmp
        mv /usr/bin/.env.tmp /usr/bin/env # atomically replace /usr/bin/env
      ''
      else ''
        rm -f /usr/bin/env
        rmdir --ignore-fail-on-non-empty /usr/bin /usr
      '';

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
            mkdir -p "$mountPoint"
            chmod 0755 "$mountPoint"
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
        wantedBy = [ "default.target" ];
      };
    };
  };

}
