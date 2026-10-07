{
  maven,
  lib,
  fetchFromGitHub,
  jre_headless,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "keycloak-config-cli";
  version = "6.5.1";

  src = fetchFromGitHub {
    owner = "adorsys";
    repo = "keycloak-config-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dSeLn9YaT0k6Mg8cxmoDoEtvjrzkyETvI4dt+q/Wj3A=";
  };

  mvnHash = "sha256-Ff9ra9ruPJ8PA0bmC8uU8PiNqjtJoR4U04veZAqZ3sM=";

  # JavaScriptEvaluatorTest needs GraalVM's Truffle engine, which fails to
  # initialize on the sandbox JDK (org.graalvm.polyglot.Engine$ImplHolder).
  doCheck = false;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  installPhase = ''
    runHook preInstall
    install -Dm444 target/keycloak-config-cli.jar $out/share/keycloak-config-cli/keycloak-config-cli.jar
    makeWrapper ${jre_headless}/bin/java $out/bin/keycloak-config-cli \
      --add-flags "-jar $out/share/keycloak-config-cli/keycloak-config-cli.jar"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/adorsys/keycloak-config-cli";
    changelog = "https://github.com/adorsys/keycloak-config-cli/releases/tag/v${finalAttrs.version}";
    description = "Import YAML/JSON-formatted configuration files into Keycloak";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jefferyoo
      anish
      vitorpavani
    ];
    mainProgram = "keycloak-config-cli";
    platforms = jre_headless.meta.platforms;
  };
})
