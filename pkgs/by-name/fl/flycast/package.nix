{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  alsa-lib,
  curl,
  libao,
  libpulseaudio,
  libzip,
  lua,
  miniupnpc,
  SDL2,
  vulkan-loader,
}:

stdenv.mkDerivation rec {
  pname = "flycast";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    tag = "v${version}";
    hash = "sha256-OnlSkwPDUrpj9uEPEAxZO1iSgd5ZiQUJLneu14v9pKQ=";
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

  meta = {
    homepage = "https://github.com/flyinghead/flycast";
    changelog = "https://github.com/flyinghead/flycast/releases/tag/v${version}";
    description = "Multi-platform Sega Dreamcast, Naomi and Atomiswave emulator";
    mainProgram = "flycast";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ];
  };
}
