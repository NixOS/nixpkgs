{ stdenv, fetchurl, pkgconfig, uilib? "framebuffer", SDL
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libnsfb";
  version = "0.1.4";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "176f8why9gzbaca9nnxjqasl02qzc6g507z5w3dzkcjifnkz4mzl";
  };

  buildInputs = [ pkgconfig buildsystem SDL ];

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
