{ stdenv, fetchurl, pkgconfig, openssl, libogg, libopus }:

stdenv.mkDerivation rec {
  name = "opusfile-0.12";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/${name}.tar.gz";
    sha256 = "02smwc5ah8nb3a67mnkjzqmrzk43j356hgj2a97s9midq40qd38i";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libogg ];
  propagatedBuildInputs = [ libopus ];
  patches = [ ./include-multistream.patch ];
  configureFlags = [ "--disable-examples" ];

  meta = with stdenv.lib; {
    description = "High-level API for decoding and seeking in .opus files";
    homepage = "http://www.opus-codec.org/";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ];
  };
}
