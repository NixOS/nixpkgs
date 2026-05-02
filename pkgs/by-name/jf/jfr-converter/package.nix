{
  lib,
  fetchFromGitHub,
  jre_headless,
  makeBinaryWrapper,
  maven,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "jfr-converter";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "async-profiler";
    repo = "async-profiler";
    tag = "v${version}";
    hash = "sha256-quXrlkG1MJNQDMYf9YIH4Kg7D8Rs5oOoCr/JoQtY25E=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  mvnHash = "sha256-Q9anERXKcwOClU16TjY6QxELTZC1P7rRNHdDsEB/v3I=";
  mvnParameters = lib.escapeShellArgs [
    "--file=pom-converter.xml"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/jfr-converter
    install -Dm644 target/jfr-converter-${version}.jar $out/share/jfr-converter/jfr-converter.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/jfr-converter \
      --add-flags "-jar $out/share/jfr-converter/jfr-converter.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility to convert between different JVM profile output formats";
    homepage = "https://github.com/async-profiler/async-profiler/blob/master/docs/ConverterUsage.md";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
    inherit (jre_headless.meta) platforms;
  };
}
