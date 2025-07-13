{
  lib,
  stdenv,
  fetchurl,
  SDL,
  pkg-config,
  buildsystem,
  uilib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libnsfb";
  version = "0.2.2";

  src = fetchurl {
    url = "https://download.netsurf-browser.org/libs/releases/libnsfb-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    SDL
    buildsystem
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
    "TARGET=${uilib}"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libnsfb/";
    description = "Netsurf framebuffer abstraction library";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
