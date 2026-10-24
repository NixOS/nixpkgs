{ lib, ... }:

{
  imports = [
    ../profiles/docker-container.nix # FIXME, shouldn't include something from profiles/
  ];

  boot.postBootCommands = ''
    # Set virtualisation to docker
    echo "docker" > /run/systemd/container
  '';

  # Prevent resolvconf from overriding Docker-managed resolv.conf.
  # Docker bind-mounts /etc/resolv.conf at container runtime and uses
  # its own embedded DNS server (127.0.0.11) for resolution. The
  # resolvconf service must not manage the file or it will conflict
  # with Docker's DNS handling. mkForce is needed because other
  # modules or user configuration may set these options.
  environment.etc."resolv.conf".enable = lib.mkForce false;
  networking.resolvconf.enable = lib.mkForce false;

  # Iptables do not work in Docker.
  networking.firewall.enable = false;

  # Socket activated ssh presents problem in Docker.
  services.openssh.startWhenNeeded = false;
}

# Example usage:
#
## default.nix
# let
#   nixos = import <nixpkgs/nixos> {
#     configuration = ./configuration.nix;
#     system = "x86_64-linux";
#   };
# in
# nixos.config.system.build.tarball
#
## configuration.nix
# { pkgs, config, lib, ... }:
# {
#   imports = [
#     <nixpkgs/nixos/modules/virtualisation/docker-image.nix>
#     <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
#   ];
#
#   documentation.doc.enable = false;
#
#   environment.systemPackages = with pkgs; [
#     bashInteractive
#     cacert
#     nix
#   ];
# }
#
## Run
# Build the tarball:
# $ nix-build default.nix
# Load into docker:
# $ docker import result/tarball/nixos-system-*.tar.xz nixos-docker
# Boots into systemd
# $ docker run --privileged -it nixos-docker /init
# Log into the container
# $ docker exec -it <container-name> /run/current-system/sw/bin/bash
