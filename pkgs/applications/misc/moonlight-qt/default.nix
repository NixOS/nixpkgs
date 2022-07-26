{ stdenv
, lib
, fetchFromGitHub
, wrapQtAppsHook
, pkg-config
, qmake
, qtquickcontrols2
, SDL2
, SDL2_ttf
, libva
, libvdpau
, libxkbcommon
, alsa-lib
, libpulseaudio
, openssl
, libopus
, ffmpeg
, wayland
}:

stdenv.mkDerivation rec {
  pname = "moonlight-qt";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CfOphr8QILCZg+UrImp5JO/1DTqoan5EwiQeTKR15Fo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    pkg-config
    qmake
  ];

  buildInputs = [
    qtquickcontrols2
    SDL2
    SDL2_ttf
    libva
    libvdpau
    libxkbcommon
    alsa-lib
    libpulseaudio
    openssl
    libopus
    ffmpeg
    wayland
  ];

  meta = with lib; {
    description = "Play your PC games on almost any device";
    homepage = "https://moonlight-stream.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
    mainProgram = "moonlight";
  };
}
