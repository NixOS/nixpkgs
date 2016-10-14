{ stdenv, fetchurl, pkgconfig, openssl, libogg, libopus }:

stdenv.mkDerivation rec {
  name = "opusfile-0.8";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/${name}.tar.gz";
    sha256 = "192mp2jgn5s9815h31ybzsfipmbppmdhwx1dymrk26xarz9iw8rc";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libogg ];
  propagatedBuildInputs = [ libopus ];
  patches = [ ./include-multistream.patch ];
  configureFlags = [ "--disable-examples" ];

  meta = {
    description = "High-level API for decoding and seeking in .opus files";
    homepage = http://www.opus-codec.org/;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
