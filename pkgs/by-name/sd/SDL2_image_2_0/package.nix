# Dependency of pygame, toppler
{ SDL2_image, fetchurl }:

SDL2_image.overrideAttrs (oldAttrs: {
  version = "2.0.5";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-vdX24CZoL31+G+C2BRsgnaL0AqLdi9HEvZwlrSYxCNA";
  };
})
