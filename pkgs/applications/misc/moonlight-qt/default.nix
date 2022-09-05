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
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/HRmyf4sW8rsNmKMrlgPvq1L8gAEa6VRCyG2w5TfGkI=";
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
