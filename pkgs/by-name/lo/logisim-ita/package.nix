{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeBinaryWrapper,
  makeDesktopItem,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "logisim-ita";
  version = "2.16.2.0";

  src = fetchurl {
    url = "https://github.com/Logisim-Ita/Logisim/releases/download/v${finalAttrs.version}/logisim-ita.jar";
    hash = "sha256-6/eoyU3kLF78M3OkHPvRu1LEyUzaXQ/BbfoG5uR9WgM=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/Logisim-Ita/Logisim/32f42d4076172e4110b74cc5d850a0f5ef5ac434/Logisim-Fork/src/main/java/resources/logisim/img/logisim-icon-128.png";
    hash = "sha256-aM8xWlsuO4d8hQ4Xlnm9cOwQnz4Af473Zm5rlNfBQS8=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "logisim-ita";
      desktopName = "Logisim-ita";
      exec = "logisim-ita";
      icon = "logisim-ita";
      comment = finalAttrs.meta.description;
      categories = [
        "Education"
        "Electronics"
        "Engineering"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeBinaryWrapper ${jre}/bin/java $out/bin/logisim-ita \
      --add-flags "-jar $src"

    install -Dm644 ${finalAttrs.icon} $out/share/icons/hicolor/128x128/apps/logisim-ita.png

    runHook postInstall
  '';

  meta = {
    description = "Educational tool for designing and simulating digital logic circuits";
    homepage = "https://github.com/Logisim-Ita/Logisim";
    changelog = "https://github.com/Logisim-Ita/Logisim/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "logisim-ita";
    maintainers = with lib.maintainers; [ kajoox ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
