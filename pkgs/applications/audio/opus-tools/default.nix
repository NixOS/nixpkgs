{stdenv, fetchurl, libogg, libao, pkgconfig, libopus, flac}:

stdenv.mkDerivation rec {
  name = "opus-tools-0.1.9";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/${name}.tar.gz";
    sha256 = "0fk4nknvl111k89j5yckmyrh6b2wvgyhrqfncp7rig3zikbkv1xi";
  };

  buildInputs = [ libogg libao pkgconfig libopus flac ];

  meta = {
    description = "Tools to work with opus encoded audio streams";
    homepage = http://www.opus-codec.org/;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
