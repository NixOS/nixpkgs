{ stdenv, fetchurl, pkgconfig, expat
, buildsystem
, libparserutils
, libwapcaplet
, libhubbub
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libdom";
  version = "0.3.3";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "1919757mdl3gii2pl6kzm8b1cal0h06r5nqd2y0kny6hc5yrhsp0";
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
    homepage = http://www.netsurf-browser.org/;
    description = "Document Object Model library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
