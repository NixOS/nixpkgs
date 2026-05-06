{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,

  nixosTests,
  alsa-lib,
  boost,
  cli11,
  cmake,
  cryptopp,
  ffmpeg,
  fmt,
  half,
  jack2,
  libdecor,
  libpng,
  libpulseaudio,
  libunwind,
  libusb1,
  magic-enum,
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
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shadps4";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadPS4";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-76rbxOf4grDWPVILy8nF35wQ6/NcxHQkmiQOB0u4oJo=";

    postCheckout = ''
      cd "$out"

      git rev-parse --short=8 HEAD > $out/COMMIT
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH

      git -C externals submodule update --init --recursive \
        glslang \
        zydis \
        sirit \
        tracy \
        ext-libusb \
        discord-rpc \
        hwinfo \
        openal-soft \
        dear_imgui \
        LibAtrac9 \
        aacdec/fdk-aac
    '';
  };

  postPatch = ''
    substituteInPlace src/common/scm_rev.cpp.in \
      --replace-fail @APP_VERSION@ ${finalAttrs.version} \
      --replace-fail @GIT_REV@ $(cat COMMIT) \
      --replace-fail @GIT_BRANCH@ ${finalAttrs.version} \
      --replace-fail @GIT_DESC@ nixpkgs \
      --replace-fail @BUILD_DATE@ $(cat SOURCE_DATE_EPOCH)

    substituteInPlace src/core/libraries/np/trophy_ui.cpp \
      --replace-fail "MIX_SetMasterGain" "MIX_SetMixerGain" \
      --replace-fail "MIX_GetMasterGain" "MIX_GetMixerGain"
  '';

  buildInputs = [
    alsa-lib
    boost
    cli11
    cryptopp
    ffmpeg
    fmt
    half
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
    zlib
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_UPDATER" false)
  ];

  # Still in development, help with debugging
  cmakeBuildType = "RelWithDebugInfo";
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -D -t $out/bin shadps4
    install -Dm644 $src/.github/shadps4.png $out/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png
    install -Dm644 -t $out/share/applications $src/dist/net.shadps4.shadPS4.desktop
    install -Dm644 -t $out/share/metainfo $src/dist/net.shadps4.shadPS4.metainfo.xml

    wrapProgram $out/bin/shadps4 \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libpulseaudio
          pipewire
        ]
      }

    runHook postInstall
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
    homepage = "https://github.com/shadps4-emu/shadPS4";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      ryand56
      liberodark
    ];
    mainProgram = "shadps4";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
  };
})
