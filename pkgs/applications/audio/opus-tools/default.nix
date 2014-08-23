{stdenv, fetchurl, libogg, libao, pkgconfig, libopus, flac}:

stdenv.mkDerivation rec {
  name = "opus-tools-0.1.8";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/${name}.tar.gz";
    sha256 = "1xm2lhdz92n9zmk496lyagisyzja46kx8q340vay9i51krbqiqg4";
  };

  buildInputs = [ libogg libao pkgconfig libopus flac ];

  meta = {
    description = "Tools to work with opus encoded audio streams";
    homepage = http://www.opus-codec.org/;
    license = "BSD";
  };
}
