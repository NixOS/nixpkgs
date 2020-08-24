{ stdenv, fetchurl, pkgconfig
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libnspsl";
  version = "0.1.6";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "02q28n5i6fwqcz1nn167rb71k1q95mx38mfah6zi1lvqrc2q5ifk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    buildsystem
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "NetSurf Public Suffix List - Handling library";
    license = licenses.mit;
    maintainers = [ maintainers.samueldr ];
    platforms = platforms.linux;
  };
}
