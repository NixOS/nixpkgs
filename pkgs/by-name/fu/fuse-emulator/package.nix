{
  lib,
  stdenv,
  fetchurl,
  perl,
  pkg-config,
  wrapGAppsHook3,
  SDL2,
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
  version = "1.10.1";

  src = fetchurl {
    url = "mirror://sourceforge/fuse-emulator/fuse-${finalAttrs.version}.tar.gz";
    hash = "sha256-9XzTDxW6xvt6hzsO5AbrABRhdpH2ZcqgHQAWJLSVPpc=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL2
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
