{ lib
, stdenv
, fetchurl
, perl
, pkg-config
, buildsystem
, libparserutils
, libwapcaplet
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libcss";
  version = "0.9.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libcss-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-0tzhbpM5Lo1qcglCDUfC1Wo4EXAaDoGnJPxUHGPTxtw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    perl
    buildsystem
    libparserutils
    libwapcaplet
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-fallthrough"
    "-Wno-error=maybe-uninitialized"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libcss/";
    description = "Cascading Style Sheets library for netsurf browser";
    longDescription = ''
      LibCSS is a CSS parser and selection engine. It aims to parse the forward
      compatible CSS grammar. It was developed as part of the NetSurf project
      and is available for use by other software, under a more permissive
      license.
    '';
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
