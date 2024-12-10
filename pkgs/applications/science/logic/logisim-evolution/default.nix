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
}:

let
  icon = fetchurl {
    url = "https://github.com/logisim-evolution/logisim-evolution/raw/9e0afa3cd6a8bfa75dab61830822cde83c70bb4b/artwork/logisim-evolution-icon.svg";
    hash = "sha256-DNRimhNFt6jLdjqv7o2cNz38K6XnevxD0rGymym3xBs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "logisim-evolution";
  version = "3.8.0";

  src = fetchurl {
    url = "https://github.com/logisim-evolution/logisim-evolution/releases/download/v${finalAttrs.version}/logisim-evolution-${finalAttrs.version}-all.jar";
    hash = "sha256-TFm+fa3CMp0OMhnKBc6cLIWGQbIG/OpOOCG7ea7wbCw=";
  };
  dontUnpack = true;

  nativeBuildInputs =
    [
      makeBinaryWrapper
      copyDesktopItems
      unzip
    ]
    ++ lib.optionals stdenv.isDarwin [
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
    makeWrapper ${jre}/bin/java $out/bin/logisim-evolution --add-flags "-jar $src"
    install -Dm444 ${icon} $out/share/icons/hicolor/scalable/apps/logisim-evolution.svg

    runHook postInstall
  '';

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
