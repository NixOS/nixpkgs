{
  lib,
  fetchurl,
  maven,
  jre,
  makeWrapper,
  stripJavaArchivesHook,
}:

maven.buildMavenPackage rec {
  pname = "fop";
  version = "2.11";

  src = fetchurl {
    url = "https://dlcdn.apache.org/xmlgraphics/fop/source/fop-${version}-src.tar.gz";
    hash = "sha256-uY6cUjmyuenfK3jAWvugsYa5qg8rbnvRZZ6qA/g2fZM=";
  };

  mvnHash = "sha256-EaOIAy0+YPrF+yGsFKKqcA4bt90bq1Z86V57P9rMatE=";

  buildOffline = true;
  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
    stripJavaArchivesHook
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 fop*/target/*.jar -t "$out/lib"
    install -Dm644 fop*/lib/*.jar -t "$out/lib"

    install -Dm644 README -t "$out/share/doc/fop"
    cp -r fop/examples/ "$out/share/doc/fop"

    # There is a fop script in the source archive, but it has many impurities.
    # Instead of patching out 90 % of the script, we write our own.
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
