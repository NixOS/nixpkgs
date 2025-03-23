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
    hash = "sha256-37pBbNACQuuEk1HJTiUHdb0mDiR2+ZsEQUOhz7mrPPg=";
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

})
