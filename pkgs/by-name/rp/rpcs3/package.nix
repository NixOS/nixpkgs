{
  lib,
  stdenv,
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
  libsm,
  ffmpeg,
  libevdev,
  libusb1,
  zlib,
  curl,
  python3,
  pugixml,
  protobuf_33,
  llvm,
  cubeb,
  opencv,
  enableDiscordRpc ? false,
  faudioSupport ? true,
  faudio,
  sdl3,
  waylandSupport ? true,
  wayland,
  wrapGAppsHook3,
  miniupnpc,
  rtmidi,
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
  version = "0.0.40-unstable-2026-04-25";

  src = fetchFromGitHub {
    owner = "RPCS3";
    repo = "rpcs3";
    rev = "96f73f4497fd6fdafd40dc50f24c95c90cd4acc9";
    postCheckout = ''
      cd $out/3rdparty
      git submodule update --init \
        fusion/fusion asmjit/asmjit yaml-cpp/yaml-cpp SoundTouch/soundtouch stblib/stb \
        feralinteractive/feralinteractive wolfssl/wolfssl
    '';
    hash = "sha256-KTF2Oj1p+EplRgWQ/We8mqu60h161/1gniKWjVAvAso=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  preConfigure = ''
    cat > ./rpcs3/git-version.h <<EOF
    #define RPCS3_GIT_VERSION "nixpkgs-${lib.sources.shortRev finalAttrs.src.rev}"
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
    (lib.cmakeBool "USE_SYSTEM_FAUDIO" true)
    (lib.cmakeBool "USE_SYSTEM_OPENAL" true)
    (lib.cmakeBool "USE_SYSTEM_PUGIXML" true)
    (lib.cmakeBool "USE_SYSTEM_PROTOBUF" true)
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
    ffmpeg
    libevdev
    zlib
    libusb1
    curl
    python3
    pugixml
    sdl3
    protobuf_33
    llvm
    libsm
    opencv.cxxdev
    cubeb
    miniupnpc
    rtmidi
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
      # Vendors wolfSSL, which changed its licence from
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
