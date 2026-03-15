{ config, pkgs, ... }:

let
  inherit (pkgs) writeScript;

  pkgs2storeContents = map (x: {
    object = x;
    symlink = "none";
  });
in

{
  # Docker image config.
  imports = [
    ../installer/cd-dvd/channel.nix
    ./minimal.nix
    ./clone-config.nix
  ];

  # Create the tarball
  system.build.tarball = pkgs.callPackage ../../lib/make-system-tarball.nix {
    contents = [
      {
        source = "${config.system.build.toplevel}/.";
        target = "./";
      }
    ];
    extraArgs = "--owner=0";

    # Add init script to image
    storeContents = pkgs2storeContents [
      config.system.build.toplevel
      pkgs.stdenv
    ];

    # Some container managers like lxc need these
    extraCommands =
      let
        script = writeScript "extra-commands.sh" ''
          rm etc
          mkdir -p proc sys dev etc
        '';
      in
      script;
  };

  boot.isContainer = true;
  boot.postBootCommands = ''
    # After booting, register the contents of the Nix store in the Nix
    # database.
    if [ -f /nix-path-registration ]; then
      ${config.nix.package.out}/bin/nix-store --load-db < /nix-path-registration &&
      rm /nix-path-registration
    fi

    # nixos-rebuild also requires a "system" profile
    ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
  '';

  # Update /init symlink when switching configurations so the container
  # boots the new system on restart.
  system.build.installBootLoader = pkgs.writeShellScript "install-docker-init" ''
    ${pkgs.coreutils}/bin/ln -fs "$1/init" /init
  '';
}
