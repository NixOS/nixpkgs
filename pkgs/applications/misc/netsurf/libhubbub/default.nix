{ stdenv, fetchurl, pkgconfig, perl
, buildsystem
, libparserutils
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libhubbub";
  version = "0.3.6";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "1x3v7xvagx85v9h3pypzc86rcxs4mij87mmcqkp8pq50q6awfmnp";
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
