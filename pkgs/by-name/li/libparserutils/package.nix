{
  lib,
  stdenv,
  fetchurl,
  perl,
  netsurf-buildsystem,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libparserutils";
  version = "0.2.5";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libparserutils-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-MX7VxxjxeSe1chl0uuXeMsP9bQVdsTGtMbQxKgMu0Tk=";
  };

  buildInputs = [
    perl
    netsurf-buildsystem
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${netsurf-buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libparserutils/";
    description = "Parser building library for netsurf browser";
    license = lib.licenses.mit;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
