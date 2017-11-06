{ config, lib, pkgs, ... }:

with lib;

let

  addAttributeName = mapAttrs (a: v: v // {
    text = ''
      #### Activation script snippet ${a}:
      ${v.text}
    '';
  });

  path = [ pkgs.coreutils ];

  activateScript = pkgs.writeScript "user-profile-activate" config.nixup.activationScripts;

in

{

  options = {

    nixup.activationScripts = mkOption {
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
        A set of shell script fragments that are executed when a NixUP
        user configuration is activated. Since these
        are executed every time you login or run
        <command>nixup-rebuild</command>, it's important that they are
        idempotent and fast.
      '';

      type = types.attrsOf types.unspecified; # FIXME

      apply = set:
        ''
          #! ${pkgs.stdenv.shell}

          if [ -n "''${NIXUP_RUNTIME_DIR:?'NIXUP_RUNTIME_DIR not set'}" ]; then
              echo "Activating NixUP user environment..."
          fi

          export PATH=/empty
          for i in ${toString path}; do
              PATH=$PATH:$i/bin:$i/sbin
          done

          _status=0
          trap "_status=1" ERR

          # Ensure a consistent umask.
          umask 0022

          # NixUP runtime directory.
          mkdir -m 0755 -p $NIXUP_RUNTIME_DIR

          # NixUP garbage collector roots directory.
          export NIXUP_USER_GCROOTS_DIR=/nix/var/nix/gcroots/nixup/$USER

          # Clean up a previously failed activation
          rm -f $NIXUP_RUNTIME_DIR/old-active-profile
          rm -f $NIXUP_USER_GCROOTS_DIR/old-active-profile

          # Move currently active profile out of the way
          if [ -e $NIXUP_RUNTIME_DIR/active-profile ]; then
              cp -d $NIXUP_RUNTIME_DIR/active-profile $NIXUP_RUNTIME_DIR/old-active-profile
          fi
          if [ -e $NIXUP_USER_GCROOTS_DIR/active-profile ]; then
              mv $NIXUP_USER_GCROOTS_DIR/active-profile $NIXUP_USER_GCROOTS_DIR/old-active-profile
          fi

          # Prevent the current configuration from being garbage-collected.
          ln -sfn @out@ $NIXUP_USER_GCROOTS_DIR/active-profile

          # Set new active profile.
          ln -sfn @out@ $NIXUP_RUNTIME_DIR/active-profile

          ${
            let
              set' = mapAttrs (n: v: if isString v then noDepEntry v else v) set;
              withHeadlines = addAttributeName set';
            in textClosureMap id (withHeadlines) (attrNames withHeadlines)
          }

          # Mark old configuration for garbage collection.
          rm -f $NIXUP_USER_GCROOTS_DIR/old-active-profile

          # Allow to keep old profile for later use in, e.g., switch-to-configuration.pl
          if [ -z $NIXUP_ACTIVATE_NO_CLEANUP ]; then
              # Remove old configuration.
              rm -f $NIXUP_RUNTIME_DIR/old-active-profile
          fi

          # Make his configuration the current configuration.
          ln -sfn "$NIXUP_RUNTIME_DIR/active-profile/sw" $HOME/.nix-profile

          exit $_status
        '';

    };

  };

  config = {
    nixup.buildCommands = ''
      cp ${toString activateScript} $out/activate
      substituteInPlace $out/activate --subst-var out
      chmod u+x $out/activate
      unset activationScript
    '';
  };
}
