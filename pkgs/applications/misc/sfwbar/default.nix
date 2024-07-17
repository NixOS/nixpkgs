{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  meson,
  ninja,
  json_c,
  pkg-config,
  gtk-layer-shell,
  libpulseaudio,
  libmpdclient,
  libxkbcommon,
  alsa-lib,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "sfwbar";
  version = "1.0_beta13";

  src = fetchFromGitHub {
    owner = "LBCrion";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7oiuTEqdXDReKdakJX6+HRaSi1XovM+MkHFkaFZtq64=";
  };

  buildInputs = [
    gtk3
    json_c
    gtk-layer-shell
    libpulseaudio
    libmpdclient
    libxkbcommon
    alsa-lib
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
  ];

  postFixup = ''
    wrapProgram $out/bin/sfwbar \
      --suffix XDG_DATA_DIRS : $out/share
  '';

  meta = with lib; {
    homepage = "https://github.com/LBCrion/sfwbar";
    description = "A flexible taskbar application for wayland compositors, designed with a stacking layout in mind";
    mainProgram = "sfwbar";
    platforms = platforms.linux;
    maintainers = with maintainers; [ NotAShelf ];
    license = licenses.gpl3Only;
  };
}
