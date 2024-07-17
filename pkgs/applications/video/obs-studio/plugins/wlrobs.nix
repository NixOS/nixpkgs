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
  version = "unstable-2023-08-23";

  src = fetchFromSourcehut {
    vc = "hg";
    owner = "~scoopta";
    repo = "wlrobs";
    rev = "f72d5cb3cbbd3983ae6cfd86cb1940be7372681c";
    hash = "sha256-hiM0d38SSUqbyisP3fAtKRLBDjVKZdU2U1xyXci7yNk=";
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
    description = "An obs-studio plugin that allows you to screen capture on wlroots based wayland compositors";
    homepage = "https://hg.sr.ht/~scoopta/wlrobs";
    maintainers = with maintainers; [ grahamc ];
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
