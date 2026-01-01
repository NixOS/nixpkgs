{
  stdenv,
  lib,
  fetchFromGitHub,
  imagemagick,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nixos-icons";
<<<<<<< HEAD
  version = "0-unstable-2025-06-28";
=======
  version = "0-unstable-2024-04-10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixos-artwork";
<<<<<<< HEAD
    rev = "9d2cdedd73d64a068214482902adea3d02783ba8";
    hash = "sha256-//4BiRF1W5W2rEbw6MupiyDOjvcveqGtYjJ1mZfck9U=";
=======
    rev = "f84c13adae08e860a7c3f76ab3a9bef916d276cc";
    hash = "sha256-lO/2dLGK2f9pzLHudRIs4PUcGUliy7kfyt9r4CbhbVg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Icons of the Nix logo, in Freedesktop Icon Directory Layout";
    homepage = "https://github.com/NixOS/nixos-artwork";
    license = lib.licenses.cc-by-40;
    maintainers = [ ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Icons of the Nix logo, in Freedesktop Icon Directory Layout";
    homepage = "https://github.com/NixOS/nixos-artwork";
    license = licenses.cc-by-40;
    maintainers = [ ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
