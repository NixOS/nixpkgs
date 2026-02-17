{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  ensureNewerSourcesForZipFilesHook,
  makeDesktopItem,
  copyDesktopItems,
  cmake,
  pkg-config,
  alsa-lib,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrender,
  libxrandr,
  libxdmcp,
  libxtst,
  xvfb,
  freetype,
  fontconfig,
  zenity,
  curl,
  python3,
  libxkbcommon,
  libGL,
  libGLU,
  libjack2,
  expat,
  webkitgtk_4_1,
  makeWrapper,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plugdata";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "plugdata-team";
    repo = "plugdata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3ldLM6M54usqjsM9veEctXVa/G14shOdp7Yi9tQi70Y=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ensureNewerSourcesForZipFilesHook
    copyDesktopItems
    python3
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    alsa-lib
    curl
    freetype
    fontconfig
    libGL
    libGLU
    libxkbcommon
    libx11
    libxcursor
    libxext
    libxinerama
    libxrender
    libxrandr
    libxdmcp
    libxtst
    xvfb
    libjack2
    expat
    webkitgtk_4_1
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "PlugData";
      desktopName = "PlugData";
      exec = "plugdata";
      icon = "plugdata_logo";
      comment = "Pure Data as a plugin, with a new GUI";
      type = "Application";
      categories = [
        "AudioVideo"
        "Music"
      ];
    })
  ];

  env.NIX_LDFLAGS = toString [
    "-lX11"
    "-lXext"
    "-lXcomposite"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
    "-lXtst"
    "-lXdmcp"
  ];

  patches = [
    # fiddle~.c prevents building with gcc15. Upstream puredata has fixed this issue,
    # but downstream vendored Plugdata has not implemented the patch yet.
    # This backports the patch.
    (fetchpatch2 {
      url = "https://github.com/pure-data/pure-data/commit/95e4105bc1044cbbcbbbcc369480a77c298d7475.patch";
      hash = "sha256-siwtizmlAS6fTOE1t+VvDKm1F14YquVlt2QAOKOGX2c=";
      stripLen = 1;
      extraPrefix = "Libraries/pure-data/";
    })
  ];

  postPatch = ''
    # Plugdata vendors its own version of Ffmpeg, and this script is used to unpack + build
    # However, its shebang is broken on nix, so we fix it here.
    patchShebangs Libraries/pd-else/Source/Shared/ffmpeg/build_ffmpeg.sh
  '';

  installPhase = ''
    runHook preInstall

    cd .. # build artifacts are placed inside the source directory for some reason
    mkdir -p $out/bin $out/lib/clap $out/lib/lv2 $out/lib/vst3
    cp    Plugins/Standalone/plugdata      $out/bin
    cp -r Plugins/CLAP/plugdata{,-fx}.clap $out/lib/clap
    cp -r Plugins/VST3/plugdata{,-fx}.vst3 $out/lib/vst3
    cp -r Plugins/LV2/plugdata{,-fx}.lv2   $out/lib/lv2

    install -Dm444 $src/Resources/Icons/plugdata_logo_linux.png $out/share/pixmaps/plugdata_logo.png

    runHook postInstall
  '';

  postInstall = ''
    # Ensure zenity is available, or it won't be able to open new files.
    wrapProgram $out/bin/plugdata \
      --prefix PATH : '${
        lib.makeBinPath [
          zenity
        ]
      }'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Plugin wrapper around Pure Data to allow patching in a wide selection of DAWs";
    mainProgram = "plugdata";
    homepage = "https://plugdata.org/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      PowerUser64
      l1npengtul
    ];
  };
})
