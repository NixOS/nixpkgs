{
  lib,
  stdenv,
  fetchurl,
  perl,
  pkg-config,
  wrapGAppsHook3,
  SDL,
  bzip2,
  glib,
  gtk3,
  libgcrypt,
  libpng,
  libspectrum,
  libxml2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fuse-emulator";
  version = "1.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/fuse-emulator/fuse-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-o/8zQwiYoPGSfydTqZmlvJkzZwLAS4ZyIg3uAdV9hdE=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL
    bzip2
    glib
    gtk3
    libgcrypt
    libpng
    libspectrum
    libxml2
    zlib
  ];

  configureFlags = [ "--enable-desktop-integration" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://fuse-emulator.sourceforge.net/";
    description = "ZX Spectrum emulator";
    mainProgram = "fuse";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
