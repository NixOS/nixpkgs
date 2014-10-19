{ config, lib, ... }:

with lib;

let
  pkgs = config.nixpkgs.pkgs;

  addAttributeName = mapAttrs (a: v: v // {
    text = ''
      #### Activation script snippet ${a}:
      ${v.text}
    '';
  });

  path = [ pkgs.coreutils ];

  activateScript = pkgs.writeScript "user-profile-activate" config.user.activationScripts;
in

{

  options = {

    user.activationScripts = mkOption {
      default = {};

      example = {
        aliasIfconfig = {
          text = ''
            # Some local configuration
            if ifconfig > /dev/null 2>&1; then
              :
            elif test -x /sbin/ifconfig; then
              ln -s /sbin/ifconfig ~/.usr/bin/ifconfig
            fi
          '';
          deps = [ "setupLocalUsr" ];
        };
      };

      description = ''
        A set of shell script fragments that are executed when a NixOS
        system configuration is activated.  Examples are updating
        <filename>~/.</filename>, creating accounts, and so on.  Since these
        are executed every time you boot the system or run
        <command>nixos-rebuild</command>, it's important that they are
        idempotent and fast.
      '';

      type = types.attrsOf types.unspecified; # FIXME

      apply = set:
        ''
          #! ${pkgs.stdenv.shell}

          userConfig=@out@
          profileLink=$HOME/.nixup/profile

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
          ln -sfn "$(readlink -f "$userConfig")" $profileLink

          # Prevent the current configuration from being garbage-collected.
          mkdir -p /nix/var/nix/gcroots/per-user/$USER/$HOME
          ln -sfn $profileLink /nix/var/nix/gcroots/per-user/$USER/$HOME/profile

          exit $_status
        '';

    };

  };

  config = {
    user.buildCommands = ''
      cp ${toString activateScript} $out/activate
      substituteInPlace $out/activate --subst-var out
      chmod u+x $out/activate
      unset activationScript
    '';
  };
}
