{ lib
, stdenv
, fetchFromSourcehut
<<<<<<< HEAD
, pkg-config
, river
, wayland
, zig_0_9
}:

stdenv.mkDerivation (finalAttrs: {
=======
, zig
, river
, wayland
, pkg-config
}:

stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "rivercarro";
  version = "0.1.4";

  src = fetchFromSourcehut {
    owner = "~novakane";
<<<<<<< HEAD
    repo = "rivercarro";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-eATbbwIt5ytEVLPodyq9vFF9Rs5S1xShpvNYQnfwdV4=";
=======
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-eATbbwIt5ytEVLPodyq9vFF9Rs5S1xShpvNYQnfwdV4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
    river
    wayland
<<<<<<< HEAD
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
=======
    zig
  ];

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline --prefix $out install
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~novakane/rivercarro";
    description = "A layout generator for river Wayland compositor, fork of rivertile";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kraem ];
  };
}

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
