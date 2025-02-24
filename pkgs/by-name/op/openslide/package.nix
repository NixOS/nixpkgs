{
  buildPackages,
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  cairo,
  doxygen,
  glib,
  gdk-pixbuf,
  libdicom,
  libjpeg,
  libpng,
  libtiff,
  libxml2,
  openjpeg,
  sqlite,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openslide";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "openslide";
    repo = "openslide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9LvQ7FG/0E0WpFyIUyrL4Fvn60iYWejjbgdKHMVOFdI=";
  };

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    doxygen
  ];

  buildInputs = [
    cairo
    glib
    gdk-pixbuf
    libdicom
    libjpeg
    libpng
    libtiff
    libxml2
    openjpeg
    sqlite
    zlib
    zstd
  ];

  meta = with lib; {
    homepage = "https://openslide.org";
    description = "C library that provides a simple interface to read whole-slide images";
    license = licenses.lgpl21;
    changelog = "https://github.com/openslide/openslide/releases/tag/v${finalAttrs.version}";
    platforms = platforms.unix;
    maintainers = with maintainers; [ lromor ];
    mainProgram = "slidetool";
  };
})
