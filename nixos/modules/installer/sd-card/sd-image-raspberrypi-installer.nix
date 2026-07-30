{
  imports = [
    ../../profiles/installation-device.nix
    ./sd-image-raspberrypi.nix
  ];

  # the installation media is also the installation target,
  # so we don't want to provide the installation configuration.nix.
  installer.cloneConfig = false;
}
