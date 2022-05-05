{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, libX11
, libevdev
, udev
, libpulseaudio
, SDL2
, libzip
, miniupnpc
}:

stdenv.mkDerivation rec {
  pname = "flycast";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "v${version}";
    sha256 = "sha256-FAHm8Fu/yv2rJvWCY+g50TYH4zOT6rO7F+jTL2T6EOU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libX11
    libevdev
    udev
    libpulseaudio
    SDL2
    libzip
    miniupnpc
  ];

  meta = with lib; {
    homepage = "https://github.com/flyinghead/flycast";
    changelog = "https://github.com/flyinghead/flycast/releases/tag/v${version}";
    description = "A multi-platform Sega Dreamcast, Naomi and Atomiswave emulator";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.ivar ];
  };
}
