{
  lib,
  stdenv,
  fetchurl,
  SDL,
  pkg-config,
  netsurf-buildsystem,
  uilib ? "gtk3",
}:

assert lib.assertOneOf "uilib" uilib [
  "framebuffer"
  "gtk2"
  "gtk3"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "libnsfb";
  version = "0.2.2";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libnsfb-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-vkRso+tU35A/LamDEdEH11dM0R9awHE+YZFW1NGeo5o=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    SDL
    netsurf-buildsystem
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${netsurf-buildsystem}/share/netsurf-buildsystem"
    "TARGET=${uilib}"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libnsfb/";
    description = "Netsurf framebuffer abstraction library";
    license = lib.licenses.mit;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
