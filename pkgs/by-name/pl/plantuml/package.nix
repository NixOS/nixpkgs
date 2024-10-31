{
  lib,
  stdenvNoCC,
  fetchurl,
  graphviz,
  jre,
  makeBinaryWrapper,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plantuml";
  version = "1.2024.7";

  src = fetchurl {
    url = "https://github.com/plantuml/plantuml/releases/download/v${finalAttrs.version}/plantuml-pdf-${finalAttrs.version}.jar";
    hash = "sha256-8BlAPc2BeojyTcZVboUA6+sOA5AO5eG871mSIWinm5E=";
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

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "plantuml --version";
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
