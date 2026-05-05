{
  stdenvNoCC,
  lib,
  fetchurl,
  electron,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenvNoCC.mkDerivation rec {
  pname = "camunda-modeler";
  version = "5.46.1";

  src = fetchurl {
    url = "https://github.com/camunda/camunda-modeler/releases/download/v${version}/camunda-modeler-${version}-linux-x64.tar.gz";
    hash = "sha256-uB+EAZgpll81RifNjKp9AkPLupbDLYHG+zFj0atsXRA=";
  };
  sourceRoot = "camunda-modeler-${version}-linux-x64";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/camunda-modeler
    cp -a {locales,resources} $out/share/camunda-modeler
    install -Dm644 support/mime-types.xml $out/share/mime/packages/camunda-modeler.xml

    for SIZE in 16 48 128; do
      install -D -m0644 support/icon_''${SIZE}.png "$out/share/icons/hicolor/''${SIZE}x''${SIZE}/apps/camunda-modeler.png"
    done

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/camunda-modeler \
      --add-flags $out/share/camunda-modeler/resources/app.asar
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      desktopName = "Camunda Modeler";
      icon = pname;
      keywords = [
        "bpmn"
        "cmmn"
        "dmn"
        "form"
        "modeler"
        "camunda"
      ];
      genericName = "Process Modeling Tool";
      comment = meta.description;
      mimeTypes = [
        "application/bpmn"
        "application/cmmn"
        "application/dmn"
        "application/camunda-form"
      ];
      extraConfig = {
        X-Ayatana-Desktop-Shortcuts = "NewWindow;RepositoryBrowser";
      };
    })
  ];

  meta = {
    homepage = "https://github.com/camunda/camunda-modeler";
    description = "Integrated modeling solution for BPMN, DMN and Forms based on bpmn.io";
    maintainers = with lib.maintainers; [
      vringar
      johannwagner
    ];
    license = lib.licenses.mit;
    inherit (electron.meta) platforms;
    mainProgram = "camunda-modeler";
  };
}
