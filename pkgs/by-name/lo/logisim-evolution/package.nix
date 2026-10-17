{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeBinaryWrapper,
  copyDesktopItems,
  makeDesktopItem,
  desktopToDarwinBundle,
  unzip,
  gitUpdater,
}:

let
  repourl = "https://github.com/logisim-evolution/logisim-evolution";
  icon = fetchurl {
    url = "${repourl}/raw/9e0afa3cd6a8bfa75dab61830822cde83c70bb4b/artwork/logisim-evolution-icon.svg";
    hash = "sha256-DNRimhNFt6jLdjqv7o2cNz38K6XnevxD0rGymym3xBs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "logisim-evolution";
  version = "4.1.0";

  src = fetchurl {
    url = "${repourl}/releases/download/v${finalAttrs.version}/logisim-evolution-${finalAttrs.version}-all.jar";
    hash = "sha256-/mOGoyF6WRvMMRpO2knh9Do4m0md09D29A80T8hfJXc=";
  };
  dontUnpack = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
    unzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "logisim-evolution";
      desktopName = "Logisim-evolution";
      exec = "logisim-evolution";
      icon = "logisim-evolution";
      comment = finalAttrs.meta.description;
      categories = [ "Education" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/logisim-evolution \
      --add-flags "-jar $src" \
      --set _JAVA_AWT_WM_NONREPARENTING 1
    install -Dm444 ${icon} $out/share/icons/hicolor/scalable/apps/logisim-evolution.svg

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    url = repourl;
  };

  meta = {
    changelog = "https://github.com/logisim-evolution/logisim-evolution/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/logisim-evolution/logisim-evolution";
    description = "Digital logic designer and simulator";
    mainProgram = "logisim-evolution";
    maintainers = with lib.maintainers; [ emilytrau ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
})
