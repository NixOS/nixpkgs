{ stdenv, fetchurl, pkgconfig, gperf
, buildsystem
, libdom
, libhubbub
, libparserutils
, libwapcaplet
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libsvgtiny";
  version = "0.1.7";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "10bpkmvfpydj74im3r6kqm9vnvgib6afy0alx71q5n0w5yawy39c";
  };

  nativeBuildInputs = [ pkgconfig gperf ];
  buildInputs = [
    buildsystem
    libdom
    libhubbub
    libparserutils
    libwapcaplet
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "NetSurf SVG decoder";
    license = licenses.mit;
    maintainers = [ maintainers.samueldr ];
    platforms = platforms.linux;
  };
}
