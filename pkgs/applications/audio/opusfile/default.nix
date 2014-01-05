{stdenv, fetchurl, pkgconfig, openssl, libogg, libopus}:

stdenv.mkDerivation rec {
  name = "opusfile-0.4";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/${name}.tar.gz";
    sha256 = "0h4iwyqgid0cibqwzckz3r94qfp09099nk1cx5nz6i3cf08yldlq";
  };

  buildInputs = [ pkgconfig openssl libogg libopus ];

  meta = {
    description = "High-level API for decoding and seeking in .opus files";
    homepage = http://www.opus-codec.org/;
    license = "BSD";
  };
}
