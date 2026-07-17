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
  version = "2.6";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lq6Oj+U4mpwNlL/t3ZB9gjE5NAVQyhdvBwLUGu1C+j0=";
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
    maintainers = [ ];
  };
})
