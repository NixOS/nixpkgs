{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "potrace-${version}";
  version = "1.14";

  src = fetchurl {
    url = "http://potrace.sourceforge.net/download/${version}/potrace-${version}.tar.gz";
    sha256 = "0znr9i0ljb818qiwm22zw63g11a4v08gc5xkh0wbdp6g259vcwnv";
  };

  configureFlags = [ "--with-libpotrace" ];

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = http://potrace.sourceforge.net/;
    description = "A tool for tracing a bitmap, which means, transforming a bitmap into a smooth, scalable image";
    platforms = platforms.unix;
    maintainers = [ maintainers.pSub ];
    license = licenses.gpl2;
  };
}
