{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  intltool,
  pkg-config,
  ffmpeg,
  wxGTK32,
  gtk3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "spek";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "alexkay";
    repo = "spek";
    rev = "v${version}";
    sha256 = "sha256-VYt2so2k3Rk3sLSV1Tf1G2pESYiXygrKr9Koop8ChCg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    ffmpeg
    wxGTK32
    gtk3
  ];

  meta = with lib; {
    description = "Analyse your audio files by showing their spectrogram";
    mainProgram = "spek";
    homepage = "http://spek.cc/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
