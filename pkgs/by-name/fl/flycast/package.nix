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
  systemdLibs,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flycast";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8qGAoMQ7hF1HFx7m+CuhxX+IG7L4fk1XQkKUYZODGmA=";
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
    systemdLibs
  ];

  cmakeFlags = [
    "-DUSE_HOST_SDL=ON"
  ];

  postFixup = ''
    wrapProgram $out/bin/flycast --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = {
    homepage = "https://github.com/flyinghead/flycast";
    changelog = "https://github.com/flyinghead/flycast/releases/tag/v${finalAttrs.version}";
    description = "Multi-platform Sega Dreamcast, Naomi and Atomiswave emulator";
    mainProgram = "flycast";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tallesCoelho ];
  };
})
