{
  lib,
  stdenv,
  callPackage,
  fetchFromSourcehut,
  pkg-config,
  river-classic,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zig_0_14,
}:

let
  zig = zig_0_14;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rivercarro";
  version = "0.6.0-unstable-2025-03-19";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = "rivercarro";
    rev = "199800235645a1771e2551a64d5b4f5e2601888c";
    fetchSubmodules = true;
    hash = "sha256-im26hiRi24tLCSvLnIdcnIWml5kTs7YSCAC8o9mcR+M=";
  };

  nativeBuildInputs = [
    pkg-config
    river-classic
    wayland
    wayland-protocols
    wayland-scanner
    zig.hook
  ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~novakane/rivercarro";
    description = "Layout generator for river Wayland compositor, fork of rivertile";
    longDescription = ''
      A slightly modified version of rivertile layout generator for river.

      Compared to rivertile, rivercarro adds:
      - Monocle layout, views will takes all the usable area on the screen.
      - Gaps instead of padding around views or layout area.
      - Modify gaps size at runtime.
      - Smart gaps, if there is only one view, gaps will be disable.
      - Limit the width of the usable area of the screen.
    '';
    changelog = "https://git.sr.ht/~novakane/rivercarro/refs/v${finalAttrs.version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kraem ];
    inherit (zig.meta) platforms;
    mainProgram = "rivercarro";
  };
})
