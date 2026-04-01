{
  lib,
  stdenv,
  fetchFromSourcehut,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stacktile";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = "stacktile";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IOFxgYMjh92jx2CPfBRZDL/1ucgfHtUyAL5rS2EG+Gc=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    wayland-scanner
  ];

  buildInputs = [
    wayland
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "MANDIR=${placeholder "man"}/share/man"
  ];

  strictDeps = true;

  meta = {
    homepage = "https://sr.ht/~leon_plickat/stacktile/";
    description = "Layout generator for the river Wayland compositor";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "stacktile";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
