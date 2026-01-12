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

stdenv.mkDerivation (finalAttrs: {
  pname = "logisim";
  version = "2.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/circuit/${lib.versions.majorMinor finalAttrs.version}.x/${finalAttrs.version}/logisim-generic-${finalAttrs.version}.jar";
    hash = "sha256-Nip4wSrRjCA/7YaIcsSgHNnBIUE3nZLokrviw35ie8I=";
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
      name = "logisim";
      desktopName = "Logisim";
      exec = "logisim";
      icon = "logisim";
      comment = finalAttrs.meta.description;
      categories = [ "Education" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/logisim --add-flags "-jar $src"

    # Create icons
    unzip $src "resources/logisim/img/*"
    for size in 16 20 24 48 64 128
    do
      install -Dm444 "./resources/logisim/img/logisim-icon-$size.png" "$out/share/icons/hicolor/''${size}x''${size}/apps/logisim.png"
    done

    runHook postInstall
  '';

  meta = {
    homepage = "http://www.cburch.com/logisim/";
    description = "Educational tool for designing and simulating digital logic circuits";
    mainProgram = "logisim";
    maintainers = with lib.maintainers; [ emilytrau ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
