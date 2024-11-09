{
  lib,
  fetchFromGitHub,
  maven,
  jre,
  makeWrapper,
  stripJavaArchivesHook,
}:

maven.buildMavenPackage rec {
  pname = "fop";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "xmlgraphics-fop";
    rev = "refs/tags/${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-vp2+RTARdTRuuXBlB956tn7qsKc6baG4qEYe3c4XtFk=";
  };

  # Note: the hash changes if we disable/enable testing
  mvnHash = "sha256-J4SgJfd6gdMMJetrzDhXgIhVgpsZJ+kXDdA97PAoW/A=";

  mvnParameters = "-DskipTests";

  nativeBuildInputs = [
    makeWrapper
    # stripJavaArchivesHook
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 fop*/target/*.jar -t "$out/lib"
    install -Dm644 README -t "$out/share/doc/fop"
    cp -r fop/examples/ "$out/share/doc/fop"

    # fop-transcoder-allinone bundles dependencies that will be used by fop-core
    # we might need to figure out a way to not have to abuse this
    makeWrapper ${lib.getExe jre} "$out/bin/fop" \
        --add-flags "-Djava.awt.headless=true" \
        --add-flags "-classpath $out/lib/\*" \
        --add-flags "org.apache.fop.cli.Main"

    runHook postInstall
  '';

  meta = {
    changelog = "https://xmlgraphics.apache.org/fop/changes.html";
    description = "XML formatter driven by XSL Formatting Objects (XSL-FO)";
    longDescription = ''
      FOP is a Java application that reads a formatting object tree and then
      turns it into a wide variety of output presentations (including AFP, PCL,
      PDF, PNG, PostScript, RTF, TIFF, and plain text), or displays the result
      on-screen.

      The formatting object tree can be in the form of an XML document (output
      by an XSLT engine like xalan) or can be passed in memory as a DOM
      Document or (in the case of xalan) SAX events.

      This package contains the fop command line tool.
    '';
    homepage = "https://xmlgraphics.apache.org/fop/";
    license = lib.licenses.asl20;
    mainProgram = "fop";
    maintainers = with lib.maintainers; [
      bjornfor
      tomasajt
    ];
    platforms = jre.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
  };
}
