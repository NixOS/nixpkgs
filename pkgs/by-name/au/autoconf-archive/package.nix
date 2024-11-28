{ lib, stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  pname = "autoconf-archive";
  version = "2024.10.16";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    hash = "sha256-e81dABkW86UO10NvT3AOPSsbrePtgDIZxZLWJQKlc2M=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  buildInputs = [ xz ];

  meta = with lib; {
    description = "Archive of autoconf m4 macros";
    homepage = "https://www.gnu.org/software/autoconf-archive/";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
