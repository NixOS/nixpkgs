{ stdenv, fetchurl, pkgconfig
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libnsutils";
  version = "0.0.2";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "03p4xmd08yhj70nyj7acjccmmshs59lv4n4zsqpsn5lgkwa23lzy";
  };

  buildInputs = [ buildsystem pkgconfig];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "Generalised utility library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
