args: with args;
stdenv.mkDerivation {
  name = "jackmeeter-0.3";

  src = fetchurl {
    url = http://www.aelius.com/njh/jackmeter/jackmeter-0.3.tar.gz;
    sha256 = "03siznnq3f0nnqyighgw9qdq1y4bfrrxs0mk6394pza3sz4b6sgp";
  };

  buildInputs = [jackaudio pkgconfig];

  meta = { 
    description = "console jack loudness meter";
    homepage = http://www.aelius.com/njh/jackmeter/;
    license = "GPLv2";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
