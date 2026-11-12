{
  lib,
  stdenv,
  fetchurl,

  # nativeBuildInputs
  pkg-config,
  gettext,
  glib,
  gobject-introspection,
  python3,
  wrapGAppsHook3,

  # buildInputs
  gtk3,
  fftw,
  libpng,
  zlib,
  openexrSupport ? true,
  openexr,
  libzipSupport ? true,
  libzip,
  libxml2Support ? true,
  libxml2,
  libwebpSupport ? true,
  libwebp,
  jsonGlibSupport ? true,
  json-glib,
  fitsSupport ? true,
  cfitsio,
  hdf5Support ? true,
  hdf5,
  bzip2Support ? true,
  bzip2,
  zstdSupport ? true,
  zstd,
  openglSupport ? !stdenv.hostPlatform.isDarwin,
  libepoxy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gwyddion";
  version = "3.12";

  src = fetchurl {
    url = "mirror://sourceforge/gwyddion/gwyddion-${finalAttrs.version}.tar.xz";
    hash = "sha256-1EWh9LcLO3xe5OnNHT0VPhWhNZIzk3YC/b9HGFx0xYg=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    glib # glib-mkenums, glib-genmarshal
    gobject-introspection
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    fftw
    libpng
    zlib
  ]
  ++ lib.optional openglSupport libepoxy
  ++ lib.optional openexrSupport openexr
  ++ lib.optional fitsSupport cfitsio
  ++ lib.optional hdf5Support hdf5
  ++ lib.optional libxml2Support libxml2
  ++ lib.optional libwebpSupport libwebp
  ++ lib.optional jsonGlibSupport json-glib
  ++ lib.optional bzip2Support bzip2
  ++ lib.optional zstdSupport zstd
  ++ lib.optional libzipSupport libzip;

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
    maintainers = with lib.maintainers; [
      doronbehar
    ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "gwyddion3";
  };
})
