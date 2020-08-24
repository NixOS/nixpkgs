{ stdenv, fetchurl, pkgconfig, perl
, buildsystem
, libwapcaplet
, libparserutils
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libcss";
  version = "0.9.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "1p66sdiiqm7w4jkq23hsf08khsnmq93hshh9f9m8sbirjdpf3p6j";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ perl
    buildsystem
    libwapcaplet
    libparserutils
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "Cascading Style Sheets library for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
