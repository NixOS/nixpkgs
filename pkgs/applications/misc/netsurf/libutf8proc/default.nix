{ stdenv, fetchurl, pkgconfig
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libutf8proc";
  version = "1.3.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "0xf659y3c6ikjnip47r30wv796a34d71p6qhc4xjs64iqszm1sbq";
  };

  buildInputs = [ buildsystem pkgconfig];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "UTF8 Processing library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
