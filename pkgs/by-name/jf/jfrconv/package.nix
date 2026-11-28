{
  lib,
  fetchFromGitHub,
  jre_headless,
  makeBinaryWrapper,
  maven,
  nix-update-script,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "jfrconv";
  version = "4.6";

  src = fetchFromGitHub {
    owner = "async-profiler";
    repo = "async-profiler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gD/VSX65RDs4dqTM0daKUYy7UbNX0DYrPz2N32Nf8Nc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  mvnHash = "sha256-tFXv+ILgOI7YDzOhb2Br5MehrlD0Om1HVmWKxgSkhRA=";
  mvnParameters = lib.escapeShellArgs [
    "--file=pom-converter.xml"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/jfrconv
    install -Dm644 target/jfr-converter-${finalAttrs.version}.jar $out/share/jfrconv/jfr-converter.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/jfrconv \
      --add-flags "-jar $out/share/jfrconv/jfr-converter.jar"

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
})
