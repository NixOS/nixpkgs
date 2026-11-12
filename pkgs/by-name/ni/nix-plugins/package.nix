{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  nixVersions,
  nixComponents ? nixVersions.nixComponents_2_34,
  cmake,
  pkg-config,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nix-plugins";
  version = "16.0.1";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = finalAttrs.version;
    hash = "sha256-1P5oVXSx/hGK5MB2grxWtmqsKGtTEmT1XD5+NSsLFUw=";
  };

  patches = [
    # nix 2.33 support, https://github.com/shlevy/nix-plugins/pull/25
    (fetchpatch2 {
      url = "https://github.com/shlevy/nix-plugins/commit/75b5f1d79923243759ddb8261df7d24df8ad2d5b.patch?full_index=1";
      hash = "sha256-mt7Zy5N7/gPEAsaURUPhhI3vM8ML7wYMa6sGy5wie+o=";
    })
    # nix 2.34 support, https://github.com/shlevy/nix-plugins/pull/26
    (fetchpatch2 {
      url = "https://github.com/shlevy/nix-plugins/commit/51ab78357ab6eb1f382c3f64bdb8fbaf742d8dec.patch?full_index=1";
      includes = [ "extra-builtins.cc" ];
      hash = "sha256-/+fuq/OEDpOy2x6vMfSXfUqXn66r10CuD6ZOnZyk8Fc=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    nixComponents.nix-expr
    nixComponents.nix-main
    nixComponents.nix-store
    nixComponents.nix-cmd
    boost
  ];

  meta = {
    description = "Collection of miscellaneous plugins for the nix expression language";
    homepage = "https://github.com/shlevy/nix-plugins";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
