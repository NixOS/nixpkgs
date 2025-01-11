# Dependency for hedgewars:
# https://github.com/NixOS/nixpkgs/pull/274185#issuecomment-1856764786
{ SDL2_image, fetchurl }:

SDL2_image.overrideAttrs (oldAttrs: {
  version = "2.6.3";
  src = fetchurl {
    inherit (oldAttrs.src) url;
    hash = "sha256-kxyb5b8dfI+um33BV4KLfu6HTiPH8ktEun7/a0g2MSw=";
  };
})
