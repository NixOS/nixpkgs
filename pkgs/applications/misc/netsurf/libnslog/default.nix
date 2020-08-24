{ stdenv, fetchurl, pkgconfig, bison, flex
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libnslog";
  version = "0.1.3";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "1l2k0kdv9iv18svhv360vszjavhl4g09cp8a8yb719pgsylxr67w";
  };

  nativeBuildInputs = [ pkgconfig bison flex ];
  buildInputs = [
    buildsystem
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "NetSurf Parametric Logging Library";
    license = licenses.mit;
    maintainers = [ maintainers.samueldr ];
    platforms = platforms.linux;
  };
}
