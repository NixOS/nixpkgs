{ stdenv, fetchurl, pkgconfig, uilib? "framebuffer", SDL
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libnsfb";
  version = "0.2.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "09qag9lgn5ahanbcyf2rvfmsz15vazfwnl8xpn8f1iczd44b0bv0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ buildsystem SDL ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
    "TARGET=${uilib}"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.netsurf-browser.org/;
    description = "CSS parser and selection library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
