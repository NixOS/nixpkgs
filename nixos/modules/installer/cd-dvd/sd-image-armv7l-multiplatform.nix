{ config, ... }:
{
  imports = [
    ../sd-card/sd-image-armv7l-multiplatform-installer.nix
  ];
  config = {
    warnings = [
      ''
        .../cd-dvd/sd-image-armv7l-multiplatform.nix is deprecated and will eventually be removed.
        Please switch to .../sd-card/sd-image-armv7l-multiplatform-installer.nix, instead.
      ''
    ];
  };
}
