{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  buildsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libutf8proc";
  version = "2.4.0-1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libutf8proc-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-AasdaYnBx3VQkNskw/ZOSflcVgrknCa+xRQrrGgCxHI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "UTF8 Processing library for netsurf browser";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
