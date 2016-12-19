{ stdenv, fetchurl, pkgconfig
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libnsgif";
  version = "0.1.3";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "1a4z45gh0fw4iybf34fig725av25h31ffk0azi0snzh4130cklnk";
  };

  buildInputs = [ buildsystem pkgconfig];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "GIF Decoder for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
