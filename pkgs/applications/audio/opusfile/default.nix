{ stdenv, fetchurl, pkgconfig, openssl, libogg, libopus }:

stdenv.mkDerivation rec {
  name = "opusfile-0.11";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/${name}.tar.gz";
    sha256 = "1gq3aszzl5glgbajw5p1f5a1kdyf23w5vjdmwwrk246syin9pkkl";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libogg ];
  propagatedBuildInputs = [ libopus ];
  patches = [ ./include-multistream.patch ];
  configureFlags = [ "--disable-examples" ];

  meta = with stdenv.lib; {
    description = "High-level API for decoding and seeking in .opus files";
    homepage = http://www.opus-codec.org/;
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ];
  };
}
