{
  lib,
  stdenv,
  fetchurl,
  expat,
  pkg-config,
  buildsystem,
  libparserutils,
  libwapcaplet,
  libhubbub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libdom";
  version = "0.4.2";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libdom-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-0F5FrxZUcBTCsKOuzzZw+hPUGfUFs/X8esihSR/DDzw=";
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
