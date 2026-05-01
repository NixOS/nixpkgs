{ config, ... }:
{
  imports = [
    ../sd-card/sd-image-raspberrypi-installer.nix
  ];
  config = {
    warnings = [
      ''
        .../cd-dvd/sd-image-raspberrypi.nix is deprecated and will eventually be removed.
        Please switch to .../sd-card/sd-image-raspberrypi-installer.nix, instead.
      ''
    ];
  };
}
