{
  lib,
  clangStdenv,
  fetchFromGitHub,
  makeBinaryWrapper,

  nixosTests,
  alsa-lib,
  boost,
  cli11,
  cmake,
  cryptopp,
  ffmpeg,
  fmt,
  freetype,
  half,
  httplib,
  jack2,
  libdecor,
  libpng,
  libpulseaudio,
  libunwind,
  libusb1,
  magic-enum,
  minimp3,
  miniupnpc,
  miniz,
  nlohmann_json,
  python3,
  libgbm,
  libx11,
  libxcb,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  libxscrnsaver,
  libxtst,
  pipewire,
  pkg-config,
  pugixml,
  rapidjson,
  renderdoc,
  robin-map,
  sdl3,
  sdl3-mixer,
  sndio,
  stb,
  toml11,
  util-linux,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
  xbyak,
  xxhash,
  zarchive,
  zstd,
  zlib,
  nix-update-script,

  withRpc ? true,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "shadps4";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadPS4";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-idlvgqiM+aBtAKRqcmQ1TnhnU2EPJYO9CPvAnKc6pMM=";

    postCheckout = ''
      git -C "$out" rev-parse --short=8 HEAD > $out/COMMIT
      date -u -d "@$(git -C "$out" log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH

      git -C "$out/externals" submodule update --init --recursive \
        abseil-cpp \
        glslang \
        zydis \
        sirit \
        tracy \
        libusb \
        discord-rpc \
        hwinfo \
        openal-soft \
        imgui \
        LibAtrac9 \
        aacdec/fdk-aac \
        spdlog \
        libressl \
        ImGuiFileDialog \
        protobuf
    '';
  };

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace src/common/scm_rev.cpp.in \
      --replace-fail @APP_VERSION@ ${finalAttrs.version} \
      --replace-fail @GIT_REV@ $(cat COMMIT) \
      --replace-fail @GIT_BRANCH@ ${finalAttrs.version} \
      --replace-fail @GIT_DESC@ nixpkgs \
      --replace-fail @BUILD_DATE@ $(cat SOURCE_DATE_EPOCH)

    sed -i '3i #include <fmt/format.h>' src/core/loader/elf.cpp

    sed -i '3i #include <cstring>' src/video_core/amdgpu/regs.cpp
    sed -i '/#pragma once/a #include <cstring>' src/video_core/amdgpu/resource.h
  '';

  env = {
    NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

    # System Zstd is not linked by default
    NIX_LDFLAGS = "-lzstd";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeBinaryWrapper
    python3
  ];

  buildInputs = [
    alsa-lib
    boost
    cli11
    cryptopp
    ffmpeg
    fmt
    freetype
    half
    httplib
    jack2
    libdecor
    libpng
    libpulseaudio
    libunwind
    libusb1
    libx11
    libxcb
    libxcursor
    libxext
    libxi
    libxrandr
    libxscrnsaver
    libxtst
    magic-enum
    minimp3
    miniupnpc
    miniz
    libgbm
    nlohmann_json
    pipewire
    pugixml
    rapidjson
    renderdoc
    robin-map
    sdl3
    sdl3-mixer
    sndio
    stb
    toml11
    util-linux
    vulkan-headers
    vulkan-loader
    vulkan-memory-allocator
    xbyak
    xxhash
    zarchive
    zstd
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_DISCORD_RPC" withRpc)
    (lib.cmakeBool "ENABLE_TESTS" false)
    (lib.cmakeBool "ENABLE_UPDATER" false)
    (lib.cmakeBool "ENABLE_SYSTEM_LIBRARIES" true)
  ];

  # Still in development, help with debugging
  cmakeBuildType = "RelWithDebugInfo";
  dontStrip = true;

  postInstall = ''
    wrapProgram $out/bin/shadps4 \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libpulseaudio
          pipewire
        ]
      }
  '';

  runtimeDependencies = [
    vulkan-loader
    libxi
  ];

  passthru = {
    tests.openorbis-example = nixosTests.shadps4;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v\\.(.*)"
      ];
    };
  };

  meta = {
    description = "Early in development PS4 emulator";
    homepage = "https://shadps4.net";
    downloadPage = "https://shadps4.net/downloads";
    donationPage = "https://ko-fi.com/shadps4";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      ryand56
      liberodark
    ];
    mainProgram = "shadps4";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
  };
})
