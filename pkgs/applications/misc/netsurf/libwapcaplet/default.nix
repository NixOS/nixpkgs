{ stdenv, fetchurl
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libwapcaplet";
  version = "0.4.2";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "1fjwzbn7j8bi1b9bvwxsy3i2cr6byq2s2d29866801pjnf528g86";
  };

  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error=cast-function-type";

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "String internment library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
