{ lib, stdenv, fetchurl, pkg-config, expat
, buildsystem
, libparserutils
, libwapcaplet
, libhubbub
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libdom";
  version = "0.4.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-mO4HJHHlXiCMmHjlFcQQrUYso2+HtK/L7K0CPzos70o=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    expat
    libhubbub
    libparserutils
    libwapcaplet
    buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
    description = "Document Object Model library for netsurf browser";
    longDescription = ''
      LibDOM is an implementation of the W3C DOM, written in C. It is currently
      in development for use with NetSurf and is intended to be suitable for use
      in other projects under a more permissive license.
    '';
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
