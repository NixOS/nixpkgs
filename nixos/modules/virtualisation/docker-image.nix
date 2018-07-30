{ ... }:

{
  imports = [
    ../profiles/docker-container.nix # FIXME, shouldn't include something from profiles/
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
