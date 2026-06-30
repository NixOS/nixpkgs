{
  lib,
  stdenv,
  fetchurl,
  perl,
  pkg-config,
  audiofile,
  bzip2,
  glib,
  libgcrypt,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspectrum";
  version = "1.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/fuse-emulator/libspectrum-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-dLsrsOeHeaCYCKp2Nv5/psgVAC6DRLRtkUv7eoZMiOA=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    audiofile
    bzip2
    glib
    libgcrypt
    zlib
  ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = {
    homepage = "https://fuse-emulator.sourceforge.net/libspectrum.php";
    description = "ZX Spectrum input and output support library";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
