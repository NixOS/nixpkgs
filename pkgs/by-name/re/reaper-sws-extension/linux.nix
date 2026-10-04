{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  php,
  perl,
  git,
  pkg-config,
  gtk3,

  pname,
  version,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = fetchFromGitHub {
    owner = "reaper-oss";
    repo = "sws";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J2igVacDClHgKGZ2WATcd5XW2FkarKtALxVLgqa90Cs=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    git
    perl
    php
    pkg-config
  ];

  buildInputs = [ gtk3 ];

  # remove after a release with https://github.com/reaper-oss/sws/commit/1eac4cba4d3f6f845c82689949f9afdfb5f35d25 lands
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
  ];

})
