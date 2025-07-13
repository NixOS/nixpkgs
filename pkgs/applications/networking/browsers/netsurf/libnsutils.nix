{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  buildsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libnsutils";
  version = "0.1.1";

  src = fetchurl {
    url = "https://download.netsurf-browser.org/libs/releases/libnsutils-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "Generalised utility library for netsurf browser";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
