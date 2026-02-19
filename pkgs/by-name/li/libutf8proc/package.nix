{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  netsurf-buildsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libutf8proc";
  version = "2.4.0-1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libutf8proc-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-AasdaYnBx3VQkNskw/ZOSflcVgrknCa+xRQrrGgCxHI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ netsurf-buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${netsurf-buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "UTF8 Processing library for netsurf browser";
    license = lib.licenses.mit;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
