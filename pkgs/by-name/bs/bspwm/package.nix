{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
  libxinerama,
  libxcb-util,
  libxcb-keysyms,
  libxcb-wm,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bspwm";
  version = "0.9.12";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "bspwm";
    tag = finalAttrs.version;
    hash = "sha256-sEheWAZgKVDCEipQTtDLNfDSA2oho9zU9gK2d6W6WSU=";
  };

  buildInputs = [
    libxcb
    libxinerama
    libxcb-util
    libxcb-keysyms
    libxcb-wm
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.tests = {
    inherit (nixosTests) startx;
  };

  meta = {
    description = "Tiling window manager based on binary space partitioning";
    homepage = "https://github.com/baskerville/bspwm";
    maintainers = with lib.maintainers; [
      meisternu
      ncfavier
    ];
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
  };
})
