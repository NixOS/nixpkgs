{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "soxr-0.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/soxr/${name}-Source.tar.xz";
    sha256 = "1hmadwqfpg15vhwq9pa1sl5xslibrjpk6hpq2s9hfmx1s5l6ihfw";
  };

  preConfigure = ''export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:"`pwd`/build/src'';

  buildInputs = [ cmake ];

  meta = {
    description = "An audio resampling library";
    homepage = http://soxr.sourceforge.net;
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
