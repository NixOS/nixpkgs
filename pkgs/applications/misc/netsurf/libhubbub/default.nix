{ stdenv, fetchurl, pkgconfig, perl
, buildsystem
, libparserutils
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libhubbub";
  version = "0.3.5";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "13yq1k96a7972x4r71i9bcsz9yiglj0yx7lj0ziq5r94w5my70ma";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ perl
    buildsystem
    libparserutils
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.netsurf-browser.org/;
    description = "HTML5 parser library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
