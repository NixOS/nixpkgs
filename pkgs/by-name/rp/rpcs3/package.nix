{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
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
  ffmpeg_7,
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
  miniupnpc,
  rtmidi,
  asmjit,
  glslang,
  zstd,
  hidapi,
  vulkan-memory-allocator,
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
  version = "0.0.38";

  src = fetchFromGitHub {
    owner = "RPCS3";
    repo = "rpcs3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HaguOzCN0/FvAb0b4RZWnw9yvVum14wEj26WnqOnSag=";
    fetchSubmodules = true;
  };

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
    (lib.cmakeBool "USE_SYSTEM_MINIUPNPC" true)
    (lib.cmakeBool "USE_SYSTEM_RTMIDI" true)
    (lib.cmakeBool "USE_SYSTEM_GLSLANG" true)
    (lib.cmakeBool "USE_SYSTEM_ZSTD" true)
    (lib.cmakeBool "USE_SYSTEM_HIDAPI" true)
    (lib.cmakeBool "USE_SYSTEM_VULKAN_MEMORY_ALLOCATOR" true)
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
    ffmpeg_7
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
    miniupnpc
    rtmidi
    asmjit
    glslang
    zstd
    hidapi
    vulkan-memory-allocator
  ]
  ++ lib.optional faudioSupport faudio
  ++ lib.optionals waylandSupport [
    wayland
    qtwayland
  ];

  patches = [
    (fetchpatch {
      name = "fix-build-qt-6.10.patch";
      url = "https://github.com/RPCS3/rpcs3/commit/038ee090b731bf63917371a3586c2f7d7cf4e585.patch";
      hash = "sha256-jTIxsheG9b9zp0JEeWQ73BunAXmEIg5tj4SrWBfdHy8=";
    })
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

  meta = {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with lib.maintainers; [
      ilian
    ];
    license = [
      lib.licenses.gpl2Only
      # Uses wolfSSL, which changed its licence from
      # `GPL-2.0-or-later` to `GPL-3.0-or-later`, which is incompatible
      # with RPCS3’s `GPL-2.0-only`. They have a “GPLv2 exception list”
      # (<https://github.com/wolfSSL/wolfssl/blob/v5.9.1-stable/LICENSING>),
      # but this is dubious; either the exception likely negates the
      # licence change by letting you take wolfSSL out of a
      # `GPL-2.0-only` combination and redistribute it under those
      # terms, negating the licence change entirely, or else it doesn’t
      # allow distribution of the combination under the `GPL-2.0-only`
      # at all and therefore would still constitute a licence
      # violation to redistribute.
      #
      # We use `lib.licenses.unfree` to represent this awkward
      # situation and keep Hydra from building the package.
      lib.licenses.gpl3Plus
      lib.licenses.unfree
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "rpcs3";
  };
})
