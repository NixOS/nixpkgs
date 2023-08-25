{ lib
, stdenv
, fetchFromSourcehut
, pkg-config
, river
, wayland
, zig_0_9
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rivercarro";
  version = "0.1.4";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = "rivercarro";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-eATbbwIt5ytEVLPodyq9vFF9Rs5S1xShpvNYQnfwdV4=";
  };

  nativeBuildInputs = [
    pkg-config
    river
    wayland
    zig_0_9.hook
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
    inherit (zig_0_9.meta) platforms;
  };
})
