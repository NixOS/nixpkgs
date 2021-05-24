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
, alsaLib
, libpulseaudio
, openssl
, libopus
, ffmpeg
}:

stdenv.mkDerivation rec {
  pname = "moonlight-qt";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bz4wjl8zydw46bh2mdbrsx8prh2fw0cmzqliy912fdz5aal2b74";
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
    alsaLib
    libpulseaudio
    openssl
    libopus
    ffmpeg
  ];

  meta = with lib; {
    description = "Play your PC games on almost any device";
    homepage = "https://moonlight-stream.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
