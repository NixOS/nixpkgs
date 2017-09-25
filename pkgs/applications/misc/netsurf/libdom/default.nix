{ stdenv, fetchurl, pkgconfig, expat
, buildsystem
, libparserutils
, libwapcaplet
, libhubbub
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libdom";
  version = "0.3.0";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "1kk6qbqagx5ypiy9kf0059iqdzyz8fqaw336vzhb5gnrzjw3wv4a";
  };

  buildInputs = [ pkgconfig expat
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
    homepage = http://www.netsurf-browser.org/;
    description = "Document Object Model library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
