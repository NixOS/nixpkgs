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
  zig_0_15,
}:

let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rivercarro";
  version = "0.6.0";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = "rivercarro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7GXtQEOxFE9PWEeFo6HgNcgs/ySwmJwrskJJ3ZSg0XU=";
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

  meta = {
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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kraem ];
    inherit (zig.meta) platforms;
    mainProgram = "rivercarro";
  };
})
