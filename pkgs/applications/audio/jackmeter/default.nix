{ stdenv, fetchurl, jackaudio, pkgconfig }:

stdenv.mkDerivation rec {
  name = "jackmeter-0.3";

  src = fetchurl {
    url = "http://www.aelius.com/njh/jackmeter/${name}.tar.gz";
    sha256 = "03siznnq3f0nnqyighgw9qdq1y4bfrrxs0mk6394pza3sz4b6sgp";
  };

  buildInputs = [ jackaudio pkgconfig ];

  meta = { 
    description = "Console jack loudness meter";
    homepage = http://www.aelius.com/njh/jackmeter/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
