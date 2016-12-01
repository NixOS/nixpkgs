{ config, pkgs, ... }:

{
  imports = [
    ../profiles/container.nix
  ];

  boot.postBootCommands =
    ''
      # Set virtualisation to docker
      echo "docker" > /run/systemd/container
    '';

  # Iptables do not work in Docker.
  networking.firewall.enable = false;

  # Socket activated ssh presents problem in Docker.
  services.openssh.startWhenNeeded = false;
}
