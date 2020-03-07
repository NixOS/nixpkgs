{ stdenv, fetchurl, pkgconfig
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libnsbmp";
  version = "0.1.5";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "0lib2m07d1i0k80m4blkwnj0g7rha4jbm5vrgd0wwbkyfa0hvk35";
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
    homepage = http://www.netsurf-browser.org/;
    description = "BMP Decoder for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
