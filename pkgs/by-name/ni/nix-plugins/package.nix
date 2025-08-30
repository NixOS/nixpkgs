{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  nixVersions,
  nixComponents ? nixVersions.nixComponents_2_30,
  cmake,
  pkg-config,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "nix-plugins";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    hash = "sha256-C4VqKHi6nVAHuXVhqvTRRyn0Bb619ez4LzgUWPH1cbM=";
  };

  patches = [
    # https://github.com/shlevy/nix-plugins/pull/22
    (fetchpatch2 {
      name = "fix-build-nix-2.28.patch";
      url = "https://github.com/shlevy/nix-plugins/commit/7279e18911fede252b95765d3920dd38b206271a.patch";
      hash = "sha256-Mwjxg7IUVrBefGz1iRJBGqkVCDqG1v8qT4StrINkXH8=";
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
}
