{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "potrace-${version}";
  version = "1.12";

  src = fetchurl {
    url = "http://potrace.sourceforge.net/download/${version}/potrace-${version}.tar.gz";
    sha256 = "0fqpfq5wwqz8j6pfh4p2pbflf6r86s4h63r8jawzrsyvpbbz3fxh";
  };

  configureFlags = [ "--with-libpotrace" ];

  buildInputs = [ zlib ];

  meta = {
    homepage = http://potrace.sourceforge.net/;
    description = "A tool for tracing a bitmap, which means, transforming a bitmap into a smooth, scalable image";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.pSub ];
    license = stdenv.lib.licenses.gpl2;
  };
}
