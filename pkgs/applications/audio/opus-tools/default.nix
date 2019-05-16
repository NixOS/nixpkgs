{stdenv, fetchurl, libogg, libao, pkgconfig, flac, opusfile, libopusenc}:

stdenv.mkDerivation rec {
  name = "opus-tools-0.2";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/${name}.tar.gz";
    sha256 = "11pzl27s4vcz4m18ch72nivbhww2zmzn56wspb7rll1y1nq6rrdl";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libogg libao flac opusfile libopusenc ];

  meta = {
    description = "Tools to work with opus encoded audio streams";
    homepage = http://www.opus-codec.org/;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
