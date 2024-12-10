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
  version = "5.28.0";

  src = fetchurl {
    url = "https://github.com/camunda/camunda-modeler/releases/download/v${version}/camunda-modeler-${version}-linux-x64.tar.gz";
    hash = "sha256-0xOgnpHoFxBzDoDGI7bcBFRu47HDYASIu4ApQo288Bo=";
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

    mkdir -p $out/bin $out/share/${pname}
    cp -a {locales,resources} $out/share/${pname}
    install -Dm644 support/mime-types.xml $out/share/mime/packages/${pname}.xml

    for SIZE in 16 48 128; do
      install -D -m0644 support/icon_''${SIZE}.png "$out/share/icons/hicolor/''${SIZE}x''${SIZE}/apps/${pname}.png"
    done

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar
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

  meta = with lib; {
    homepage = "https://github.com/camunda/camunda-modeler";
    description = "An integrated modeling solution for BPMN, DMN and Forms based on bpmn.io";
    maintainers = teams.wdz.members;
    license = licenses.mit;
    inherit (electron.meta) platforms;
    mainProgram = "camunda-modeler";
  };
}
