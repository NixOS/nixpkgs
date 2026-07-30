{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  xorgproto,
  libxcb,
  libxcb-keysyms,
  libx11,
  i3ipc-glib,
  glib,
}:

stdenv.mkDerivation {
  pname = "i3easyfocus";
  version = "20190411";

  src = fetchFromGitHub {
    owner = "cornerman";
    repo = "i3-easyfocus";
    rev = "fffb468f7274f9d7c9b92867c8cb9314ec6cf81a";
    hash = "sha256-1XHEAZYlzQsKn5E3eLpUVzSjPkBtuqC1sxDc+v8eYrU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxcb
    libxcb-keysyms
    xorgproto
    libx11.dev
    i3ipc-glib
    glib.dev
  ];

  # Makefile has no rule for 'install'
  installPhase = ''
    mkdir -p $out/bin
    cp i3-easyfocus $out/bin
  '';

  meta = {
    description = "Focus and select windows in i3";
    mainProgram = "i3-easyfocus";
    homepage = "https://github.com/cornerman/i3-easyfocus";
    maintainers = with lib.maintainers; [ teto ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
