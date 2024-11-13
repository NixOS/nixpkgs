{ lib
, stdenv
, callPackage
, fetchFromSourcehut
, pkg-config
, river
, wayland
, wayland-protocols
, wayland-scanner
, zig_0_12
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rivercarro";
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = "rivercarro";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-nDKPv/roweW7ynEROsipUJPvs6VMmz3E4JzEFRBzE6s=";
  };

  nativeBuildInputs = [
    pkg-config
    river
    wayland
    wayland-protocols
    wayland-scanner
    zig_0_12.hook
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
    inherit (zig_0_12.meta) platforms;
    mainProgram = "rivercarro";
  };
})
