{
  lib,
  bmake,
  pkg-config,
  wayland-scanner,
  fontconfig,
  pixman,
  freetype,
  libdrm,
  wayland,
  stdenv,
  fetchFromSourcehut,
}:
stdenv.mkDerivation {
  pname = "neuwld";
  version = "0.0";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuwld";
    rev = "235b7b62be7d7c9eefa011eac4a5b78ba7390f1c";
    hash = "sha256-0+rgWrefh19bBEmcqw0Lal1PHkendtCkQ2EIg+LHb74=";
  };

  nativeBuildInputs = [
    bmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    fontconfig
    pixman
    freetype
    libdrm
    wayland
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Drawing library that targets Wayland";
    homepage = "https://git.sr.ht/~shrub900/neuwld";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ricardomaps ];
    platforms = lib.platforms.linux;
  };
}
