{ stdenv, fetchurl, pkgconfig, uilib? "framebuffer", SDL
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libnsfb";
  version = "0.2.2";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "16m3kv8x8mlic4z73h2s3z8lqmyp0z8i30x95lzr1pslxfinqi5y";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ buildsystem SDL ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
    "TARGET=${uilib}"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "CSS parser and selection library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
