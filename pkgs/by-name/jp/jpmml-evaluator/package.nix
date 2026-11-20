{
  lib,
  maven,
  fetchFromGitHub,
  makeBinaryWrapper,
  jre_headless,
  nix-update-script,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "jpmml-evaluator";
  version = "1.7.7";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jpmml";
    repo = "jpmml-evaluator";
    tag = finalAttrs.version;
    hash = "sha256-DtI/cHmiKVH0IAp3mWJr2sDDjAzM5d9/cBx4KJm74WM=";
  };

  # Upstream's pom.xml declares commons-math3 and guava as open Maven version
  # ranges ("[3.1, 3.6.1]", "[19.0, 33.5.0-jre]"), which forces Maven to
  # query Central's maven-metadata.xml at resolve time to pick the highest
  # matching version — a live network lookup that produces different results
  # across machines/times, causing mvnHash drift. Pin them to the exact
  # upper-bound versions the ranges resolve to today.
  postPatch = ''
    substituteInPlace pom.xml \
      --replace-fail \
        '<commons-math3.version>[3.1, 3.6.1]</commons-math3.version>' \
        '<commons-math3.version>3.6.1</commons-math3.version>' \
      --replace-fail \
        '<guava.version>[19.0, 33.5.0-jre]</guava.version>' \
        '<guava.version>33.5.0-jre</guava.version>'
  '';

  mvnHash = "sha256-xnFwQGjLEX59zeYKX+R7+F9hRRmRXtkP6Xw2hRi6Jbc=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java $out/bin
    cp pmml-evaluator-example/target/pmml-evaluator-example-executable-*.jar $out/share/java/jpmml-evaluator.jar

    makeBinaryWrapper ${lib.getExe jre_headless} $out/bin/jpmml-evaluator \
      --add-flags "-jar $out/share/java/jpmml-evaluator.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Java Evaluator API for PMML";
    homepage = "https://github.com/jpmml/jpmml-evaluator";
    changelog = "https://github.com/jpmml/jpmml-evaluator/releases/tag/${finalAttrs.version}";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.b-rodrigues ];
    mainProgram = "jpmml-evaluator";
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
})
