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
  moltenvk,
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

  patches = [
    ./fix-darwin-objective-cxx-pch.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    curl
    libao
    libpulseaudio
    libzip
    lua
    miniupnpc
    SDL2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    systemdLibs
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ moltenvk ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        '"$ENV{VULKAN_SDK}/lib/libMoltenVK.dylib"' \
        '"${moltenvk}/lib/libMoltenVK.dylib"'
  '';

  cmakeFlags = [
    "-DUSE_HOST_SDL=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DUSE_BREAKPAD=OFF"
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
    "-DZLIB_LIBRARY=" # Unsets broken default for Darwin.
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/flycast --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv "$out/bin/Flycast.app" "$out/Applications/"
    rm -rf "$out/include" "$out/lib" "$out/bin"
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
