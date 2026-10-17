{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  fcitx5,
  gettext,
  go,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-bamboo";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-bamboo";
    rev = finalAttrs.version;
    hash = "sha256-/gfnHSKlNQ0fl8wnn2iFQ1LYIwPP97YNdAasLbY/ovI=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    gettext
    go
  ];

  buildInputs = [
    kdePackages.extra-cmake-modules
    fcitx5
  ];

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
  '';

  meta = {
    description = "Vietnamese input method engine support for Fcitx";
    homepage = "https://github.com/fcitx/fcitx5-bamboo";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
