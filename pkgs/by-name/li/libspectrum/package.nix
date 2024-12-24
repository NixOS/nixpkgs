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

stdenv.mkDerivation rec {
  pname = "libspectrum";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/fuse-emulator/${pname}-${version}.tar.gz";
    sha256 = "sha256-o1PLRumxooEGHYFjU+oBDQpv545qF6oLe3QnHKXkrPw=";
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

  meta = with lib; {
    homepage = "https://fuse-emulator.sourceforge.net/libspectrum.php";
    description = "ZX Spectrum input and output support library";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
