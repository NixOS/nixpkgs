{ stdenv, fetchurl, pkgconfig, bison, flex
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libnslog";
  version = "0.1.3";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-/JjcqdfvpnCWRwpdlsAjFG4lv97AjA23RmHHtNsEU9A=";
  };

  nativeBuildInputs = [ pkgconfig bison flex ];
  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "https://www.netsurf-browser.org/";
    description = "NetSurf Parametric Logging Library";
    license = licenses.isc;
    maintainers = [ maintainers.samueldr maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
