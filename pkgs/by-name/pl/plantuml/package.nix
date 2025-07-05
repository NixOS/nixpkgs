{
  lib,
  stdenvNoCC,
  fetchurl,
  graphviz,
  gitUpdater,
  jre,
  makeBinaryWrapper,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plantuml";
  version = "1.2025.3";

  src = fetchurl {
    url = "https://github.com/plantuml/plantuml/releases/download/v${finalAttrs.version}/plantuml-pdf-${finalAttrs.version}.jar";
    hash = "sha256-o8bBO9Crcrf2XLuLbakSiUp4WcIanJJTRwlDr4ydL0I=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildCommand = ''
    install -Dm644 $src $out/lib/plantuml.jar

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/plantuml \
      --argv0 plantuml \
      --set GRAPHVIZ_DOT ${graphviz}/bin/dot \
      --add-flags "-jar $out/lib/plantuml.jar"
  '';

  doInstallCheck = true;

  postCheckInstall = ''
    $out/bin/plantuml -help
    $out/bin/plantuml -testdot
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "plantuml --version";
    };
    updateScript = gitUpdater {
      url = "https://github.com/plantuml/plantuml.git";
      allowedVersions = "^1\\.[0-9\\.]+$";
      rev-prefix = "v";
    };
  };

  meta = {
    description = "Draw UML diagrams using a simple and human readable text description";
    homepage = "https://plantuml.com/";
    # "plantuml -license" says GPLv3 or later
    license = lib.licenses.gpl3Plus;
    mainProgram = "plantuml";
    maintainers = with lib.maintainers; [
      bjornfor
      Mogria
      anthonyroussel
    ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
