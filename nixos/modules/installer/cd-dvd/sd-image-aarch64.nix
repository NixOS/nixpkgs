{ config, ... }:
{
  imports = [
    ../sd-card/sd-image-aarch64-installer.nix
  ];
  config = {
    warnings = [
      ''
      .../cd-dvd/sd-image-aarch64.nix is deprecated and will eventually be removed.
      Please switch to .../sd-card/sd-image-aarch64-installer.nix, instead.
      ''
    ];
  };
}
