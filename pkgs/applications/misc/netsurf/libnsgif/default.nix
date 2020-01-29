{ stdenv, fetchurl, pkgconfig
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libnsgif";
  version = "0.2.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "0jwshypgmx16xlsbx3d8njk8a5khazlplca5mxd3rdbhrlsabbly";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ buildsystem];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.netsurf-browser.org/;
    description = "GIF Decoder for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.unix;
  };
}
