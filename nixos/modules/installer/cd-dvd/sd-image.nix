{ config, ... }:
{
  imports = [
    ../sd-card/sd-image.nix
  ];
  config = {
    warnings = [
      ''
        .../cd-dvd/sd-image.nix is deprecated and will eventually be removed.
        Please switch to .../sd-card/sd-image.nix, instead.
      ''
    ];
  };
}
