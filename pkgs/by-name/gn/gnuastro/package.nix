{ lib, stdenv, fetchurl, libtool
, cfitsio, curl, ghostscript, gsl, libgit2, libjpeg, libtiff, lzlib, wcslib }:

stdenv.mkDerivation rec {
  pname = "gnuastro";
  version = "0.23";

  src = fetchurl {
    url = "mirror://gnu/gnuastro/gnuastro-${version}.tar.gz";
    sha256 = "sha256-+X53X/tZgcY/it++lY/Ov5FHwT8OfpZAfd398zs/dwI=";
  };

  nativeBuildInputs = [ libtool ];

  buildInputs = [
    cfitsio
    curl
    ghostscript
    gsl
    libgit2
    libjpeg
    libtiff
    lzlib
    wcslib
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "GNU astronomy utilities and library";
    homepage = "https://www.gnu.org/software/gnuastro/";
    changelog = "https://git.savannah.gnu.org/cgit/gnuastro.git/plain/NEWS?id=gnuastro_v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
