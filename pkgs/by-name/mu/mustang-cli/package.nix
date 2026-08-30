{
  lib,
  fetchFromGitHub,
  maven,
  jre_minimal,
  jdk_headless,
  makeWrapper,
  stripJavaArchivesHook,
  nix-update-script,
}:
let
  jre = jre_minimal.override {
    modules = [
      "java.base"
      "java.desktop"
      "java.logging"
    ];
    jdk = jdk_headless;
  };
in
maven.buildMavenPackage (finalAttrs: {
  version = "2.26.0";
  pname = "mustang-cli";

  src = fetchFromGitHub {
    owner = "ZUGFeRD";
    repo = "mustangproject";
    tag = "core-${finalAttrs.version}";
    hash = "sha256-34wR6n/FAWRN7tL0pl+luc7RLER6Bsy0e03gSkoS1+4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  mvnHash = "sha256-zLXu0VY9F1jtoTZZ0Q/pswNK5nmjN4aCdvSTAoHQg6k=";

  nativeBuildInputs = [
    makeWrapper
    stripJavaArchivesHook
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/Mustang-CLI

    # Upstream hardcodes an incorrect version string in the generated JAR filename, use a glob to match it.
    # Use correct version when https://github.com/ZUGFeRD/mustangproject/issues/1131 is fixed.
    install -Dm644 Mustang-CLI/target/Mustang-CLI-*-SNAPSHOT.jar $out/share/Mustang-CLI/Mustang-CLI.jar

    makeWrapper ${jre}/bin/java $out/bin/mustang-cli \
      --add-flags "-jar $out/share/Mustang-CLI/Mustang-CLI.jar"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=core-(.*)"
    ];
  };

  meta = {
    mainProgram = "mustang-cli";
    description = "Open Source Java e-Invoicing library, validator and tool (Factur-X/ZUGFeRD, UNCEFACT/CII XRechnung)";
    homepage = "https://www.mustangproject.org";
    changelog = "https://github.com/ZUGFeRD/mustangproject/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ angelodlfrtr ];
  };
})
