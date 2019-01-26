{ stdenv, fetchurl, pkgconfig, perl
, buildsystem
, libwapcaplet
, libparserutils
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libcss";
  version = "0.8.0";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "0pxdqbxn6brj03nv57bsvac5n70k4scn3r5msaw0jgn2k06lk81m";
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

  NIX_CFLAGS_COMPILE=[ "-Wno-error=implicit-fallthrough" ];

  meta = with stdenv.lib; {
    homepage = http://www.netsurf-browser.org/;
    description = "Cascading Style Sheets library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
