{ lib, stdenv, fetchurl, argtable }:

stdenv.mkDerivation rec {
  version = "1.2.4";
  pname = "clustal-omega";

  src = fetchurl {
    url = "http://www.clustal.org/omega/${pname}-${version}.tar.gz";
    sha256 = "1vm30mzncwdv881vrcwg11vzvrsmwy4wg80j5i0lcfk6dlld50w6";
  };

  buildInputs = [ argtable ];

  preConfigure = ''
    for f in configure \
             src/clustal-omega-config.h \
             src/clustal-omega-config.h \
             src/config.h.in \
             src/mymain.c
    do
      sed -i -re 's/argtable2/argtable3/g' $f
    done
  '';

  meta = with lib; {
    description = "General purpose multiple sequence alignment program for protein and DNA/RNA";
    homepage = "http://www.clustal.org/omega/";
    license = licenses.gpl2;
    maintainers = [ maintainers.bzizou ];
    mainProgram = "clustalo";
    platforms = platforms.unix;
  };
}
