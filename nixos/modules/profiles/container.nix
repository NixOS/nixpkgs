{ config, lib, pkgs, ... }:

with lib;

let
 pkgs2storeContents = l : map (x: { object = x; symlink = "none"; }) l;

in {
  # Docker image config.
  imports = [
    ../installer/cd-dvd/channel.nix
    ./minimal.nix
    ./clone-config.nix
  ];

  # Create the tarball
  system.build.tarball = import ../../lib/make-system-tarball.nix {
    inherit (pkgs) stdenv perl xz pathsFromGraph;

    contents = [];
    extraArgs = "--owner=0";

    # Add init script to image
    storeContents = [
      { object = config.system.build.toplevel + "/init";
        symlink = "/init";
      }
    ] ++ (pkgs2storeContents [ pkgs.stdenv ]);

    # Some container managers like lxc need these
    extraCommands = "mkdir -p proc sys dev";
  };

  boot.isContainer = true;
  boot.postBootCommands =
    ''
      # After booting, register the contents of the Nix store in the Nix
      # database.
      if [ -f /nix-path-registration ]; then
        ${config.nix.package}/bin/nix-store --load-db < /nix-path-registration &&
        rm /nix-path-registration
      fi

      # nixos-rebuild also requires a "system" profile
      ${config.nix.package}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
    '';

  # Disable some features that are not useful in a container.
  sound.enable = mkDefault false;
  services.udisks2.enable = mkDefault false;

  # Install new init script
  system.activationScripts.installInitScript = ''
    ln -fs $systemConfig/init /init
  '';
}
