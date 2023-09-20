{ lib
, stdenv
, fetchurl
, expat
, pkg-config
, buildsystem
, libparserutils
, libwapcaplet
, libhubbub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libdom";
  version = "0.4.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libdom-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-mO4HJHHlXiCMmHjlFcQQrUYso2+HtK/L7K0CPzos70o=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    expat
    buildsystem
    libhubbub
    libparserutils
    libwapcaplet
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libdom/";
    description = "Document Object Model library for netsurf browser";
    longDescription = ''
      LibDOM is an implementation of the W3C DOM, written in C. It is currently
      in development for use with NetSurf and is intended to be suitable for use
      in other projects under a more permissive license.
    '';
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
