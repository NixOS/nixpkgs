{
  maven,
  lib,
  fetchFromGitHub,
  jre_headless,
  makeWrapper,
  nix-update-script,
}:
maven.buildMavenPackage rec {
  pname = "keycloak-config-cli";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "adorsys";
    repo = "keycloak-config-cli";
    tag = "v${version}";
    hash = "sha256-Vg56Dz9U0eAJw+7u90MSZWmMIZttWYGXAwsXZsEfTj8=";
  };

  mvnHash = "sha256-tdh8hRqGXI3zuwy55dC3La9dm2naqeCEZT4qcw37iDI=";

  # Tests use MockServer which needs to bind to a local port
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ makeWrapper ];

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
    description = "Import YAML/JSON-formatted configuration files into Keycloak";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      anish
    ];
    mainProgram = "keycloak-config-cli";
    platforms = jre_headless.meta.platforms;
  };
}
