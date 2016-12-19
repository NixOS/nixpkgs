{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "potrace-${version}";
  version = "1.13";

  src = fetchurl {
    url = "http://potrace.sourceforge.net/download/${version}/potrace-${version}.tar.gz";
    sha256 = "115p2vgyq7p2mf4nidk2x3aa341nvv2v8ml056vbji36df5l6lk2";
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
