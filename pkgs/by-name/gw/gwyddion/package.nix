{
  lib,
  stdenv,
  fetchurl,
  gtk2,
  pkg-config,
  fftw,
  file,
  gnome2,
  openexrSupport ? true,
  openexr,
  libzipSupport ? true,
  libzip,
  libxml2Support ? true,
  libxml2,
  libwebpSupport ? true,
  libwebp,
  # libXmu is not used if libunique is.
  libXmuSupport ? false,
  xorg,
  libxsltSupport ? true,
  libxslt,
  fitsSupport ? true,
  cfitsio,
  zlibSupport ? true,
  zlib,
  libuniqueSupport ? true,
  libunique,
  libpngSupport ? true,
  libpng,
  openglSupport ? !stdenv.hostPlatform.isDarwin,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "gwyddion";
  version = "2.67";
  src = fetchurl {
    url = "mirror://sourceforge/gwyddion/gwyddion-${version}.tar.xz";
    sha256 = "sha256-kK6vTeADc2lrC+9KgqxFtih62ce3rKYkkGjU0qT8jWE=";
  };

  nativeBuildInputs = [
    pkg-config
    file
  ];

  buildInputs =
    [
      gtk2
      fftw
    ]
    ++ lib.optionals openglSupport [
      gnome2.gtkglext
      libGL
    ]
    ++ lib.optional openexrSupport openexr
    ++ lib.optional libXmuSupport xorg.libXmu
    ++ lib.optional fitsSupport cfitsio
    ++ lib.optional libpngSupport libpng
    ++ lib.optional libxsltSupport libxslt
    ++ lib.optional libxml2Support libxml2
    ++ lib.optional libwebpSupport libwebp
    ++ lib.optional zlibSupport zlib
    ++ lib.optional libuniqueSupport libunique
    ++ lib.optional libzipSupport libzip;

  # This patch corrects problems with python support, but should apply cleanly
  # regardless of whether python support is enabled, and have no effects if
  # it is disabled.
  patches = [ ./codegen.patch ];
  meta = {
    homepage = "http://gwyddion.net/";

    description = "Scanning probe microscopy data visualization and analysis";

    longDescription = ''
      A modular program for SPM (scanning probe microscopy) data
      visualization and analysis. Primarily it is intended for the
      analysis of height fields obtained by scanning probe microscopy
      techniques (AFM, MFM, STM, SNOM/NSOM) and it supports a lot of
      SPM data formats. However, it can be used for general height
      field and (greyscale) image processing, for instance for the
      analysis of profilometry data or thickness maps from imaging
      spectrophotometry.
    '';
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [ ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
}
