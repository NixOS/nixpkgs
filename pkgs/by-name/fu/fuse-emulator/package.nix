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

stdenv.mkDerivation rec {
  pname = "fuse-emulator";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/fuse-${version}.tar.gz";
    sha256 = "sha256-Oo/t8v/pR8VxVhusVaWa2tTFkzj3TkSbfnpn2coEcJY=";
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

  meta = with lib; {
    homepage = "https://fuse-emulator.sourceforge.net/";
    description = "ZX Spectrum emulator";
    mainProgram = "fuse";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
