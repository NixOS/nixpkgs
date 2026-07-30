{
  stdenv,
  lib,
  fetchFromGitHub,
  imagemagick,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nixos-icons";
  version = "0-unstable-2025-06-28";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixos-artwork";
    rev = "9d2cdedd73d64a068214482902adea3d02783ba8";
    hash = "sha256-//4BiRF1W5W2rEbw6MupiyDOjvcveqGtYjJ1mZfck9U=";
  };

  sourceRoot = "${finalAttrs.src.name}/icons";

  strictDeps = true;

  nativeBuildInputs = [
    imagemagick
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Icons of the Nix logo, in Freedesktop Icon Directory Layout";
    homepage = "https://github.com/NixOS/nixos-artwork";
    license = lib.licenses.cc-by-40;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
