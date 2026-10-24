{
  lib,
  stdenv,
  fetchzip,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  makeWrapper,
  libGL,
  libx11,
  libxext,
  libxrender,
  libxtst,
  libxi,
  fontconfig,
  alsa-lib,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pixiv-multiplatform";
  version = "1.8.4";

  src = fetchzip {
    url = "https://github.com/magic-cucumber/Pixiv-MultiPlatform/releases/download/v${finalAttrs.version}/linux.tar.gz";
    hash = "sha256-HrshexFChp5ZurSNXq4qFT3GdLuMz64nIrzPMKSbobU=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    libGL
    libx11
    libxext
    libxrender
    libxtst
    libxi
    fontconfig
    alsa-lib
    stdenv.cc.cc
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{opt,share/icons/hicolor/256x256/apps}
    cp -r . $out/opt/Pixiv-MultiPlatform
    ln -s $out/opt/Pixiv-MultiPlatform/lib/Pixiv-MultiPlatform.png $out/share/icons/hicolor/256x256/apps/pixiv-multiplatform.png
    makeWrapper $out/opt/Pixiv-MultiPlatform/bin/Pixiv-MultiPlatform $out/bin/Pixiv-MultiPlatform \
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          webkitgtk_4_1
          gtk3
          libsoup_3
          sqlite
        ]
      }

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      comment = finalAttrs.meta.description;
      name = "pixiv-multiplatform";
      desktopName = "Pixiv-MultiPlatform";
      exec = "Pixiv-MultiPlatform %U";
      icon = "pixiv-multiplatform";
      categories = [ "Network" ];
    })
  ];

  meta = {
    description = "Cross-platform third-party Pixiv client based on Kotlin technology stack";
    homepage = "https://pmf.kagg886.top";
    changelog = "https://github.com/magic-cucumber/Pixiv-MultiPlatform/releases";
    downloadPage = "https://github.com/magic-cucumber/Pixiv-MultiPlatform/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "Pixiv-MultiPlatform";
  };
})
