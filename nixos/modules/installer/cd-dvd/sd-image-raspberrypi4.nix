{ config, ... }:
{
  imports = [
    ../sd-card/sd-image-raspberrypi4-installer.nix
  ];
  config = {
    warnings = [
      ''
      .../cd-dvd/sd-image-raspberrypi4.nix is deprecated and will eventually be removed.
      Please switch to .../sd-card/sd-image-raspberrypi4-installer.nix, instead.
      ''
    ];
  };
}
