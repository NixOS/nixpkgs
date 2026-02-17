{
  lib,
  gcc14Stdenv,
  fetchFromGitHub,

  nixosTests,
  alsa-lib,
  boost,
  cmake,
  cryptopp,
  game-music-emu,
  glslang,
  ffmpeg,
  flac,
  fluidsynth,
  fmt,
  half,
  jack2,
  libdecor,
  libGL,
  libpulseaudio,
  libunwind,
  libusb1,
  libvorbis,
  libxmp,
  libgbm,
  libx11,
  libxcb,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  libxscrnsaver,
  libxtst,
  magic-enum,
  mpg123,
  pipewire,
  pkg-config,
  pugixml,
  rapidjson,
  renderdoc,
  robin-map,
  sndio,
  stb,
  toml11,
  util-linux,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
  xbyak,
  xxHash,
  zlib-ng,
  zydis,
  nix-update-script,
}:

# relies on std::sinf & co, which was broken in GCC until GCC 14: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79700
gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "shadps4";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadPS4";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-zc3zhFTphty/vwioFEOfhgXttpD9MG2F7+YJYcW0H2w=";
    fetchSubmodules = true;

    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short=8 HEAD > $out/COMMIT
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  postPatch = ''
    substituteInPlace src/common/scm_rev.cpp.in \
      --replace-fail @APP_VERSION@ ${finalAttrs.version} \
      --replace-fail @GIT_REV@ $(cat COMMIT) \
      --replace-fail @GIT_BRANCH@ ${finalAttrs.version} \
      --replace-fail @GIT_DESC@ nixpkgs \
      --replace-fail @BUILD_DATE@ $(cat SOURCE_DATE_EPOCH)
  '';

  buildInputs = [
    alsa-lib
    boost
    cryptopp
    game-music-emu
    glslang
    ffmpeg
    flac
    fluidsynth
    fmt
    half
    jack2
    libdecor
    libGL
    libpulseaudio
    libunwind
    libusb1
    libvorbis
    libxmp
    libx11
    libxcb
    libxcursor
    libxext
    libxi
    libxrandr
    libxscrnsaver
    libxtst
    libgbm
    magic-enum
    mpg123
    pipewire
    pugixml
    rapidjson
    renderdoc
    robin-map
    sndio
    stb
    toml11
    util-linux
    vulkan-headers
    vulkan-loader
    vulkan-memory-allocator
    xbyak
    xxHash
    zlib-ng
    zydis
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
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
