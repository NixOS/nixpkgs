{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bstring";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "msteinert";
    repo = "bstring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-efXMSRcPgo+WlOdbS1kY2PYQqSVwcsVSyU1JfsU8OOo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  meta = {
    description = "Better String Library for C";
    homepage = "https://github.com/msteinert/bstring";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
