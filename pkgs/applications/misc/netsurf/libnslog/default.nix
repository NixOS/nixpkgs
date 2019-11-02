{ stdenv, fetchurl, pkgconfig, bison, flex
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libnslog";
  version = "0.1.2";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "1ggs6xvxp8fbg5w8pifalipm458ygr9ab6j2yvj8fnnmxwvdh4jd";
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
    homepage = http://www.netsurf-browser.org/;
    description = "NetSurf Parametric Logging Library";
    license = licenses.mit;
    maintainers = [ maintainers.samueldr ];
    platforms = platforms.linux;
  };
}
