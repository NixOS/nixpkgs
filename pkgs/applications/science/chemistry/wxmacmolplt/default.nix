{
  stdenv,
  lib,
  fetchFromGitHub,
  wxGTK32,
  libGL,
  libGLU,
  pkg-config,
  xorg,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "wxmacmolplt";
  version = "7.7.3";

  src = fetchFromGitHub {
    owner = "brettbode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gFGstyq9bMmBaIS4QE6N3EIC9GxRvyJYUr8DUvwRQBc=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    wxGTK32
    libGL
    libGLU
    xorg.libX11
    xorg.libX11.dev
  ];

  configureFlags = [ "LDFLAGS=-lGL" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Graphical user interface for GAMESS-US";
    mainProgram = "wxmacmolplt";
    homepage = "https://brettbode.github.io/wxmacmolplt/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      sheepforce
      markuskowa
    ];
  };
}
