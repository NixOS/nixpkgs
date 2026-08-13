{
  lib,
  clangStdenv,
  fetchFromGitHub,
  fetchpatch2,
  makeWrapper,

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

let
  abseilCppSrc = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    tag = "20250512.1";
    hash = "sha256-eB7OqTO9Vwts9nYQ/Mdq0Ds4T1KgmmpYdzU09VPWOhk=";
  };
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "shadps4";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadPS4";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-Z3UwxK+0D3RXKTM0ybYG4U42bInjF05KlMXzxN4UcNg=";

    postCheckout = ''
      git -C "$out" rev-parse --short=8 HEAD > $out/COMMIT
      date -u -d "@$(git -C "$out" log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH

      git -C "$out/externals" submodule update --init --recursive \
        glslang \
        zydis \
        sirit \
        tracy \
        libusb \
        discord-rpc \
        hwinfo \
        openal-soft \
        dear_imgui \
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

  patches = [
    # https://github.com/shadps4-emu/shadPS4/pull/4786
    (fetchpatch2 {
      name = "use-system-zarchive.patch";
      url = "https://github.com/shadps4-emu/shadPS4/commit/71c48b43570ac8df545d3d96261b0ec7fa37c808.patch?full_index=1";
      hash = "sha256-MQiw+DGi/85nTSAVrNw2GmwhbBD7/Xy3lCIDMg1HxxU=";
    })
  ];

  postPatch = ''
    substituteInPlace src/common/scm_rev.cpp.in \
      --replace-fail @APP_VERSION@ ${finalAttrs.version} \
      --replace-fail @GIT_REV@ $(cat COMMIT) \
      --replace-fail @GIT_BRANCH@ ${finalAttrs.version} \
      --replace-fail @GIT_DESC@ nixpkgs \
      --replace-fail @BUILD_DATE@ $(cat SOURCE_DATE_EPOCH)
  '';

  # System Zstd is not linked by default
  env.NIX_LDFLAGS = "-lzstd";

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
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
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ABSL" "${abseilCppSrc}")
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
