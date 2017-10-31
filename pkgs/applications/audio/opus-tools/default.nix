{stdenv, fetchurl, libogg, libao, pkgconfig, libopus, flac}:

stdenv.mkDerivation rec {
  name = "opus-tools-0.1.10";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/${name}.tar.gz";
    sha256 = "135jfb9ny3xvd27idsxj7j5ns90lslbyrq70cq3bfwcls4r7add2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libogg libao libopus flac ];

  meta = {
    description = "Tools to work with opus encoded audio streams";
    homepage = http://www.opus-codec.org/;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
