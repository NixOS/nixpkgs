{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, makeWrapper
, alsa-lib
, curl
, libao
, libpulseaudio
, libzip
, lua
, miniupnpc
, SDL2
, vulkan-loader
}:

stdenv.mkDerivation rec {
  pname = "flycast";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "v${version}";
    sha256 = "sha256-YFLSUaEikwLPglHh3t8sHiKHRn5cchKzzkJlZDdgVsU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    curl
    libao
    libpulseaudio
    libzip
    lua
    miniupnpc
    SDL2
  ];

  cmakeFlags = [
    "-DUSE_HOST_SDL=ON"
  ];

  postFixup = ''
    wrapProgram $out/bin/flycast --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/flyinghead/flycast";
    changelog = "https://github.com/flyinghead/flycast/releases/tag/v${version}";
    description = "A multi-platform Sega Dreamcast, Naomi and Atomiswave emulator";
    mainProgram = "flycast";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.ivar ];
  };
}
