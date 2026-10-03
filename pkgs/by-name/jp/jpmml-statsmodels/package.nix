{
  lib,
  fetchFromGitHub,
  maven,
  jre_headless,
  makeBinaryWrapper,
  nix-update-script,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "jpmml-statsmodels";
  version = "1.3.13";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jpmml";
    repo = "jpmml-statsmodels";
    tag = finalAttrs.version;
    hash = "sha256-QVJhJliHLST5MJV9OZVC+jTk8vV+bUu7i2IL6GSqK34=";
  };

  mvnHash = "sha256-jhn6qWvM4TZdu3tsaNuyOXdTaIX8scfFvRkeSlPQXH0=";

  # go-offline-maven-plugin only fetches pinned JARs/POMs, not the
  # ever-changing maven-metadata.xml timestamps, avoiding one source of
  # hash drift. This does NOT cover unpinned build-plugin versions
  # (compiler, jar, shade, etc.), which resolve from whatever defaults
  # ship with nixpkgs' current `maven` and drift on every maven bump —
  # see fix-plugin-versions.patch, which pins those explicitly.
  buildOffline = true;

  # go-offline-maven-plugin cannot handle "dynamic" test dependencies
  # (those resolved at test runtime rather than declared in the POM).
  # List them explicitly so they end up in the offline repo.
  manualMvnArtifacts = [
    "org.apache.maven.surefire:surefire-junit-platform:3.5.4"
    "org.junit.jupiter:junit-jupiter-engine:5.14.3"
    "org.junit.platform:junit-platform-launcher:1.14.3"
    "org.apache.maven.plugins:maven-resources-plugin:3.4.0"
  ];

  # Pins otherwise-unversioned build plugins (compiler, jar, shade,
  # enforcer, jacoco, resources, surefire) so they don't drift with
  # nixpkgs' maven bumps — see comment on buildOffline above.
  patches = [ ./fix-plugin-versions.patch ];

  mvnParameters = "-B package";

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/java" "$out/bin"
    install -Dm444 \
      pmml-statsmodels-example/target/pmml-statsmodels-example-executable-${finalAttrs.version}.jar \
      "$out/share/java/jpmml-statsmodels.jar"

    makeBinaryWrapper ${lib.getExe jre_headless} "$out/bin/jpmml-statsmodels" \
      --add-flags "-jar $out/share/java/jpmml-statsmodels.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Java library and CLI for converting StatsModels models to PMML";
    longDescription = ''
      JPMML-StatsModels converts Python StatsModels fitted model results
      (serialized as Pickle files) into the Predictive Model Markup Language
      (PMML) format, enabling deployment of those models on the JVM via
      JPMML-Evaluator.

      Supported model families include OLS/WLS/QuantReg linear regression,
      GLMs (Binomial, Gaussian, Poisson), Logit, MNLogit, Poisson count
      models, OrderedModel, and ARIMA time-series models.
    '';
    homepage = "https://github.com/jpmml/jpmml-statsmodels";
    changelog = "https://github.com/jpmml/jpmml-statsmodels/releases/tag/${finalAttrs.version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ b-rodrigues ];
    mainProgram = "jpmml-statsmodels";
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
})
