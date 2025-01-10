{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  buildsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libnspsl";
  version = "0.1.6";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libnspsl-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-08WCBct40xC/gcpVNHotCYcZzsrHBGvDZ5g7E4tFAgs=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "NetSurf Public Suffix List - Handling library";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
