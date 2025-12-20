{ lib, ... }:
{
  virtualisation.docker = {
    enable = lib.mkForce false;
  };

  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman, to use it as a drop-in replacement
    # dockerCompat = true;
    dockerSocket = {
      enable = true;
    };

    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;

    autoPrune = {
      dates = "weekly";
      flags = [
        "--filter"
        "label!=no-prune"
        "--volumes"
        "--log-level"
        "debug"
      ];
    };
  };

  virtualisation.containers.storage.settings = {
    storage = {
      driver = "overlay";
      graphroot = "/var/lib/containers/storage";
      runroot = "/run/containers/storage";

      # Does not work currently.
      options.overlay = {
        mountopt = "nodev,metacopy=on";
      };
    };
  };
}
