{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,
  cmake,
  pkg-config,
  git,
  qt6Packages,
  openal,
  glew,
  vulkan-headers,
  vulkan-loader,
  libpng,
  libSM,
  ffmpeg,
  libevdev,
  libusb1,
  zlib,
  curl,
  wolfssl,
  python3,
  pugixml,
  flatbuffers,
  llvm_18,
  cubeb,
  opencv,
  enableDiscordRpc ? false,
  faudioSupport ? true,
  faudio,
  SDL2,
  sdl3,
  waylandSupport ? true,
  wayland,
  wrapGAppsHook3,
}:

let
  inherit (qt6Packages)
    qtbase
    qtmultimedia
    wrapQtAppsHook
    qtwayland
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rpcs3";
  version = "0.0.37";

  src = fetchFromGitHub {
    owner = "RPCS3";
    repo = "rpcs3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/ve1qe76Rc+mXHemq8DI2U9IP6+tPV5m5SNh/wmppEw=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/RPCS3/rpcs3/pull/17316
      url = "https://github.com/RPCS3/rpcs3/commit/bad6e992586264344ee1a3943423863d2bd39b45.patch?full_index=1";
      hash = "sha256-rSyA1jcmRiV6m8rPKqTnDFuBh9WYFTGmyTSU2qrd+Go=";
    })
  ];

  passthru.updateScript = nix-update-script { };

  preConfigure = ''
    cat > ./rpcs3/git-version.h <<EOF
    #define RPCS3_GIT_VERSION "nixpkgs"
    #define RPCS3_GIT_FULL_BRANCH "RPCS3/rpcs3/master"
    #define RPCS3_GIT_BRANCH "HEAD"
    #define RPCS3_GIT_VERSION_NO_UPDATE 1
    EOF
  '';

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_ZLIB" true)
    (lib.cmakeBool "USE_SYSTEM_LIBUSB" true)
    (lib.cmakeBool "USE_SYSTEM_LIBPNG" true)
    (lib.cmakeBool "USE_SYSTEM_FFMPEG" true)
    (lib.cmakeBool "USE_SYSTEM_CURL" true)
    (lib.cmakeBool "USE_SYSTEM_WOLFSSL" true)
    (lib.cmakeBool "USE_SYSTEM_FAUDIO" true)
    (lib.cmakeBool "USE_SYSTEM_OPENAL" true)
    (lib.cmakeBool "USE_SYSTEM_PUGIXML" true)
    (lib.cmakeBool "USE_SYSTEM_FLATBUFFERS" true)
    (lib.cmakeBool "USE_SYSTEM_SDL" true)
    (lib.cmakeBool "USE_SYSTEM_OPENCV" true)
    (lib.cmakeBool "USE_SYSTEM_CUBEB" true)
    (lib.cmakeBool "USE_SDL" true)
    (lib.cmakeBool "WITH_LLVM" true)
    (lib.cmakeBool "BUILD_LLVM" false)
    (lib.cmakeBool "USE_NATIVE_INSTRUCTIONS" false)
    (lib.cmakeBool "USE_DISCORD_RPC" enableDiscordRpc)
    (lib.cmakeBool "USE_FAUDIO" faudioSupport)
  ];

  dontWrapGApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    git
    wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    openal
    glew
    vulkan-headers
    vulkan-loader
    libpng
    ffmpeg
    libevdev
    zlib
    libusb1
    curl
    wolfssl
    python3
    pugixml
    SDL2 # Still needed by FAudio's CMake
    sdl3
    flatbuffers
    llvm_18
    libSM
    opencv.cxxdev
    cubeb
  ]
  ++ lib.optional faudioSupport faudio
  ++ lib.optionals waylandSupport [
    wayland
    qtwayland
  ];

  doInstallCheck = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    # Taken from https://wiki.rpcs3.net/index.php?title=Help:Controller_Configuration
    install -D ${./99-ds3-controllers.rules} $out/etc/udev/rules.d/99-ds3-controllers.rules
    install -D ${./99-ds4-controllers.rules} $out/etc/udev/rules.d/99-ds4-controllers.rules
    install -D ${./99-dualsense-controllers.rules} $out/etc/udev/rules.d/99-dualsense-controllers.rules
  '';

  meta = with lib; {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [
      ilian
    ];
    license = licenses.gpl2Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "rpcs3";
  };
})
