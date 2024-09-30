{ config, ... }:
{
  imports = [
    ../sd-card/sd-image-aarch64-new-kernel-installer.nix
  ];
  config = {
    warnings = [
      ''
      .../cd-dvd/sd-image-aarch64-new-kernel.nix is deprecated and will eventually be removed.
      Please switch to .../sd-card/sd-image-aarch64-new-kernel-installer.nix, instead.
      ''
    ];
  };
}
