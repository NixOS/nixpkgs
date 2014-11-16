{ config, lib, pkgs, ... }:

with lib;

let
 pkgs2storeContents = l : map (x: { object = x; symlink = "none"; }) l;

in {
  # Create the tarball
  system.build.dockerImage = import ../../lib/make-system-tarball.nix {
    inherit (pkgs) stdenv perl xz pathsFromGraph;

    contents = [];
    extraArgs = "--owner=0";
    storeContents = [
      { object = config.system.build.toplevel + "/init";
        symlink = "/bin/init";
      }
    ] ++ (pkgs2storeContents [ pkgs.stdenv ]);
  };

  boot.postBootCommands =
    ''
      # After booting, register the contents of the Nix store in the Nix
      # database.
      if [ -f /nix-path-registration ]; then
        ${config.nix.package}/bin/nix-store --load-db < /nix-path-registration &&
        rm /nix-path-registration
      fi

      # nixos-rebuild also requires a "system" profile and an
      # /etc/NIXOS tag.
      touch /etc/NIXOS
      ${config.nix.package}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system

      # Set virtualisation to docker
      echo "docker" > /run/systemd/container 
    '';


  # Docker image config.
  imports = [
    ../installer/cd-dvd/channel.nix
    ../profiles/minimal.nix
    ../profiles/clone-config.nix
  ];

  boot.isContainer = true;

  # Iptables do not work in Docker.
  networking.firewall.enable = false;

  services.openssh.enable = true;

  # Socket activated ssh presents problem in Docker.
  services.openssh.startWhenNeeded = false;

  # Allow the user to login as root without password.
  users.extraUsers.root.initialHashedPassword = mkOverride 150 "";

  # Some more help text.
  services.mingetty.helpLine =
    ''

      Log in as "root" with an empty password.
    '';
}
