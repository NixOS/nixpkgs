{stdenv, fetchurl, libogg, libao, pkgconfig, libopus}:

stdenv.mkDerivation rec {
  name = "opus-tools-0.1.6";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/${name}.tar.gz";
    sha256 = "1hd2ych34y3qy4rj4hd5cp29ixy891afizlsxphsfvfplk1dp1nc";
  };

  buildInputs = [ libogg libao pkgconfig libopus ];

  meta = {
    description = "Tools to work with opus encoded audio streams";
    homepage = http://www.opus-codec.org/;
    license = "BSD";
  };
}
