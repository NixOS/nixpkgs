{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "potrace";
  version = "1.15";

  src = fetchurl {
    url = "http://potrace.sourceforge.net/download/${version}/potrace-${version}.tar.gz";
    sha256 = "17ajildjp14shsy339xarh1lw1p0k60la08ahl638a73mh23kcx9";
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
