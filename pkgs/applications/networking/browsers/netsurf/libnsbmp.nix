{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  buildsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libnsbmp";
  version = "0.1.7";

  src = fetchurl {
    url = "https://download.netsurf-browser.org/libs/releases/libnsbmp-${finalAttrs.version}-src.tar.gz";
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
    description = "BMP Decoder for netsurf browser";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
