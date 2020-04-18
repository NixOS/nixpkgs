{ stdenv, fetchurl, pkgconfig, expat
, buildsystem
, libparserutils
, libwapcaplet
, libhubbub
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libdom";
  version = "0.4.0";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "1ixkqsl3f7dl1kajksm0c231w1v5xy8z6hm3v67hgm9nh4qcvfcy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ expat
    buildsystem
    libparserutils
    libwapcaplet
    libhubbub
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "Document Object Model library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
