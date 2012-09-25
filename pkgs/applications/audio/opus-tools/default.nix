{stdenv, fetchurl, libogg, libao, pkgconfig, libopus}:

stdenv.mkDerivation rec {
  name = "opus-tools-0.1.5";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/${name}.tar.gz";
    sha256 = "0184zfamg3qcjknk4liz4smws3mbv77gjhq2pn9xgcx9nw78srvn";
  };

  buildInputs = [ libogg libao pkgconfig libopus ];

  meta = {
    description = "Tools to work with opus encoded audio streams";
    homepage = http://www.opus-codec.org/;
    license = "BSD";
  };
}
