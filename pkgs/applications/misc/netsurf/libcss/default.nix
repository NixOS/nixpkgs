{ stdenv, fetchurl, pkgconfig, perl
, buildsystem
, libwapcaplet
, libparserutils
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libcss";
  version = "0.9.0";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "1vw9j3d2mr4wbvs8fyqmgslkbxknvac10456775hflxxcivbm3xr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ perl
    buildsystem
    libwapcaplet
    libparserutils
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  NIX_CFLAGS_COMPILE= "-Wno-error=implicit-fallthrough";

  meta = with stdenv.lib; {
    homepage = http://www.netsurf-browser.org/;
    description = "Cascading Style Sheets library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
