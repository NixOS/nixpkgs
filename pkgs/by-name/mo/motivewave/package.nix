{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  alsa-lib,
  atk,
  bc,
  cairo,
  ffmpeg,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  libGL,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  libxxf86vm,
  libz,
  pango,
  xrandr,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "motivewave";
  version = "7.0.22";

  buildNumber = "636";

  src = fetchurl {
    url = "https://downloads.motivewave.com/builds/${finalAttrs.buildNumber}/motivewave_${finalAttrs.version}_amd64.deb";
    hash = "sha256-PZ94CSKn99LiIntt5hyPfxRNVUMVE8GHfuEml2oAr2M=";
  };

  nativeBuildInputs = [
    dpkg
    copyDesktopItems
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc
    alsa-lib
    atk
    cairo
    ffmpeg
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libGL
    libx11
    libxext
    libxi
    libxrender
    libxtst
    libxxf86vm
    libz
    pango
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libavcodec*.so.*"
    "libavformat*.so.*"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "motivewave";
      desktopName = "MotiveWave";
      exec = "motivewave";
      icon = "motivewave";
      type = "Application";
      genericName = "Trading/Charting Software";
      comment = "Advanced trading and charting application";
      categories = [
        "Office"
        "Finance"
      ];
      keywords = [
        "Trading"
        "Charting"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mv usr/share/motivewave/icons usr/share/icons
    mkdir -p usr/share/icons/hicolor/256x256/apps
    mv usr/share/icons/mwave_256x256.png usr/share/icons/hicolor/256x256/apps/motivewave.png
    rm usr/share/applications/motivewave.desktop

    substituteInPlace usr/share/motivewave/run.sh \
      --replace-fail /usr/share/motivewave $out/share/motivewave

    mkdir -p $out/bin
    mv usr/share $out

    # Setting GDK_CORE_DEVICE_EVENTS is necessary to fix the scroll wheel in JavaFX.
    # See: https://stackoverflow.com/a/77535959
    makeWrapper $out/share/motivewave/run.sh $out/bin/motivewave \
      --set GDK_CORE_DEVICE_EVENTS 1 \
      --prefix PATH : ${
        lib.makeBinPath [
          bc
          xrandr
        ]
      } \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Advanced trading and charting application";
    homepage = "https://www.motivewave.com/";
    license = with lib.licenses; [ unfree ];
    maintainers = with lib.maintainers; [ jakehpark ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "motivewave";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
