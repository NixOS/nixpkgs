{
  lib,
  stdenv,
  fetchFromGitHub,
  ensureNewerSourcesForZipFilesHook,
  makeDesktopItem,
  copyDesktopItems,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  webkitgtk_4_1,
  zenity,
  curl,
  xorg,
  python3,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libxkbcommon,
  libdatrie,
  libepoxy,
  libGL,
  libjack2,
  lerc,
  sqlite,
  expat,
  makeWrapper,
  nix-update-script,
}:
let
  version = "0.9.1";
in
stdenv.mkDerivation {
  pname = "plugdata";
  inherit version;

  src = fetchFromGitHub {
    owner = "plugdata-team";
    repo = "plugdata";
    tag = "v${version}";
    hash = "sha256-dcggq455lZiwl1lps11fuKX6sx0A8UtFwFoiBJWtwFQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ensureNewerSourcesForZipFilesHook
    copyDesktopItems
    python3
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    curl
    freetype
    webkitgtk_4_1
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXrender
    xorg.libXrandr
    xorg.libXdmcp
    xorg.libXtst
    xorg.xvfb
    libsysprof-capture
    pcre2
    util-linux
    libGL
    libselinux
    libsepol
    libthai
    libxkbcommon
    libdatrie
    libepoxy
    lerc
    libjack2
    expat
    sqlite
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

  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcomposite"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
      "-lXtst"
      "-lXdmcp"
    ]
  );

  preBuild = ''
    # fix LV2 build
    HOME=$(mktemp -d)
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
    maintainers = [
      lib.maintainers.PowerUser64
      lib.maintainers.l1npengtul
    ];
  };
}
