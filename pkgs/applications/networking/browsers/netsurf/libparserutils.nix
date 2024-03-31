{ lib
, stdenv
, fetchurl
, perl
, buildsystem
, iconv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libparserutils";
  version = "0.2.5";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libparserutils-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-MX7VxxjxeSe1chl0uuXeMsP9bQVdsTGtMbQxKgMu0Tk=";
  };

  buildInputs = [
    perl
    buildsystem
    iconv
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libparserutils/";
    description = "Parser building library for netsurf browser";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
