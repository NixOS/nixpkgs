{ stdenv, fetchurl, pkgconfig, perl
, buildsystem
, libwapcaplet
, libparserutils
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libcss";
  version = "0.6.0";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "0qp4p1q1dwgdra4pkrzd081zjzisxkgwx650ijx323j8bj725daf";
  };

  buildInputs = [ pkgconfig perl
    buildsystem
    libwapcaplet
    libparserutils
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.netsurf-browser.org/;
    description = "Cascading Style Sheets library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
