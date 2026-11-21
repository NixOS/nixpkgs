{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  gfortran,

  alsa-lib,
  cairo,
  fontconfig,
  freetype,
  glib,
  gtk3,
  libGL,
  libx11,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libxxf86vm,
  libxcb,
  libxkbcommon,
  pango,
  wayland,
  zlib,
}:

let
  runtimeLibs = [
    alsa-lib
    cairo
    fontconfig
    freetype
    glib
    gtk3
    libGL

    libx11
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    libxxf86vm

    libxcb
    libxkbcommon
    pango
    wayland
    zlib

    stdenv.cc.cc.lib
    gfortran.cc.lib
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "qupath";
  version = "0.7.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/qupath/qupath/releases/download/v${finalAttrs.version}/QuPath-v${finalAttrs.version}-Linux.tar.xz";
    hash = "sha256-Fl4noHMdWLoDnp0NNKVKz4lruS6BkiNw3ylcuFQYzlM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
    wrapGAppsHook3
  ];

  buildInputs = runtimeLibs;

  dontConfigure = true;
  dontBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = "qupath";
      desktopName = "QuPath";
      genericName = "Digital Pathology Image Analysis";
      comment = "Bioimage analysis and digital pathology";
      exec = "qupath %F";
      icon = "qupath";
      terminal = false;
      categories = [
        "Graphics"
        "Science"
        "Education"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/qupath
    cp -r ./* $out/lib/qupath/

    mkdir -p $out/bin

    makeWrapper \
      $out/lib/qupath/bin/QuPath \
      $out/bin/qupath \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

    install -Dm644 \
      $out/lib/qupath/lib/QuPath.png \
      $out/share/icons/hicolor/128x128/apps/qupath.png

    runHook postInstall
  '';

  meta = {
    description = "Open source software for bioimage analysis and digital pathology";
    homepage = "https://qupath.github.io/";
    changelog = "https://github.com/qupath/qupath/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;

    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];

    maintainers = with lib.maintainers; [
      edfork
    ];

    platforms = [ "x86_64-linux" ];
    mainProgram = "qupath";
  };
})
