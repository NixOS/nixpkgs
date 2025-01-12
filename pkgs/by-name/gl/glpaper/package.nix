{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  pkg-config,
  wayland,
  libX11,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "glpaper";
  version = "unstable-2022-05-15";

  src = fetchFromSourcehut {
    owner = "~scoopta";
    repo = pname;
    vc = "hg";
    rev = "f89e60b7941fb60f1069ed51af9c5bb4917aab35";
    sha256 = "sha256-E7FKjt3NL0aAEibfaq+YS2IVvpjNjInA+Rs8SU63/3M=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    wayland
    libX11 # required by libglvnd
    libGL
  ];

  meta = with lib; {
    description = "Wallpaper program for wlroots based Wayland compositors such as sway that allows you to render glsl shaders as your wallpaper";
    mainProgram = "glpaper";
    homepage = "https://hg.sr.ht/~scoopta/glpaper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ccellado ];
  };
}
