# This module defines a standard configuration for NixOS shells.

{ config, lib, pkgs, ... }:

with lib;

{

  config = {

    environment.shellAliases =
      { ls = "ls --color=tty";
        ll = "ls -l";
        l  = "ls -alh";
      };

    environment.shellInit =
      ''
        # Set up the per-user profile.
        mkdir -m 0755 -p $NIX_USER_PROFILE_DIR
        if test "$(stat --printf '%u' $NIX_USER_PROFILE_DIR)" != "$(id -u)"; then
            echo "WARNING: bad ownership on $NIX_USER_PROFILE_DIR" >&2
        fi

        if test -w $HOME; then
          ${if ! config.nixup.enable then ''
          if ! test -L $HOME/.nix-profile; then
              if test "$USER" != root; then
                  ln -s $NIX_USER_PROFILE_DIR/profile $HOME/.nix-profile
              else
                  # Root installs in the system-wide profile by default.
                  ln -s /nix/var/nix/profiles/default $HOME/.nix-profile
              fi
          fi
          '' else
             let
               defaultProfile = pkgs.writeText "nixup-default-profile"
                 ''
                   # NixUP configuration root file

                   {config, lib, pkgs, ...}:

                   with lib;

                   {
                     config = {

                     };

                   }
                 '';
             in ''
          # Create default nixup configuration directory

          if ! test -e ''${XDG_CONFIG_HOME:-$HOME/.config}/nixup; then
              mkdir -m 0755 -p ''${XDG_CONFIG_HOME:-$HOME/.config}/nixup
          fi
          if [ -d ''${XDG_CONFIG_HOME:-$HOME/.config}/nixup -a ! -e ''${XDG_CONFIG_HOME:-$HOME/.config}/nixup/profile.nix ]; then
              cat ${defaultProfile} > ''${XDG_CONFIG_HOME:-$HOME/.config}/nixup/profile.nix
          fi
          ''}

          # Subscribe the root user to the NixOS channel by default.
          if [ "$USER" = root -a ! -e $HOME/.nix-channels ]; then
              echo "${config.system.defaultChannel} nixos" > $HOME/.nix-channels
          fi

          # Create the per-user garbage collector roots directory.
          NIX_USER_GCROOTS_DIR=/nix/var/nix/gcroots/per-user/$USER
          mkdir -m 0755 -p $NIX_USER_GCROOTS_DIR
          if test "$(stat --printf '%u' $NIX_USER_GCROOTS_DIR)" != "$(id -u)"; then
              echo "WARNING: bad ownership on $NIX_USER_GCROOTS_DIR" >&2
          fi

          # Set up a default Nix expression from which to install stuff.
          if [ ! -e $HOME/.nix-defexpr -o -L $HOME/.nix-defexpr ]; then
              rm -f $HOME/.nix-defexpr
              mkdir -p $HOME/.nix-defexpr
              if [ "$USER" != root ]; then
                  ln -s /nix/var/nix/profiles/per-user/root/channels $HOME/.nix-defexpr/channels_root
              fi
          fi
        fi
      '';

  };

}
