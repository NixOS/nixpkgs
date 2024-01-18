{ lib
, stdenv
, fetchFromSourcehut
, pkg-config
, river
, wayland
, wayland-protocols
, zig_0_11
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rivercarro";
  version = "0.3.0";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = "rivercarro";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-lucwn9MmyVd4pynuG/ZAXnZ384wdS0gi7JN44vNQA1I=";
  };

  nativeBuildInputs = [
    pkg-config
    river
    wayland
    wayland-protocols
    zig_0_11.hook
  ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~novakane/rivercarro";
    description = "A layout generator for river Wayland compositor, fork of rivertile";
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
    inherit (zig_0_11.meta) platforms;
  };
})
