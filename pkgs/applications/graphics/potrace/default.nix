{ stdenv, fetchurl, zlib }:

let version = "1.11"; in

stdenv.mkDerivation {
  name = "potrace-${version}";

  src = fetchurl {
    url = "http://potrace.sourceforge.net/download/potrace-${version}.tar.gz";
    sha256 = "1bbyl7jgigawmwc8r14znv8lb6lrcxh8zpvynrl6s800dr4yp9as";
  };

  configureFlags = ["--with-libpotrace"];

  buildInputs = [ zlib ];

  meta = {
    homepage = http://potrace.sourceforge.net/;
    description = "A tool for tracing a bitmap, which means, transforming a bitmap into a smooth, scalable image";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.pSub ];
    license = "GPL2";
  };
}
