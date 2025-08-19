{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  pkg-config,
  ninja,
  wayland,
  obs-studio,
  libX11,
}:

stdenv.mkDerivation {
  pname = "wlrobs";
  version = "unstable-2024-12-24";

  src = fetchFromSourcehut {
    vc = "hg";
    owner = "~scoopta";
    repo = "wlrobs";
    rev = "b8668b4d6d6d33e3de86ce3fa4331249bc0abc8b";
    hash = "sha256-gqGnDrfID5hTcpX3EkSGg4yDwa/ZKCQCqJ3feq44I1I=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];
  buildInputs = [
    wayland
    obs-studio
    libX11
  ];

  meta = with lib; {
    description = "Obs-studio plugin that allows you to screen capture on wlroots based wayland compositors";
    homepage = "https://hg.sr.ht/~scoopta/wlrobs";
    maintainers = with maintainers; [ grahamc ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
