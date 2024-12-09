{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
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
  version = "2.4";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "v${version}";
    hash = "sha256-1Rso7/S95+8KPoKa+3oFPJBWE+YGw4Qqo3Hn+crxNio=";
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
    description = "Multi-platform Sega Dreamcast, Naomi and Atomiswave emulator";
    mainProgram = "flycast";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
