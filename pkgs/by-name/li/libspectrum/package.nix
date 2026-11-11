{
  lib,
  stdenv,
  fetchurl,
  perl,
  pkg-config,
  bzip2,
  glib,
  libgcrypt,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspectrum";
  version = "1.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/fuse-emulator/libspectrum-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-OjMi+QbwVJhxY8LpcHFgt82jAu5G1kERx8tuwzrcnQQ=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
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
