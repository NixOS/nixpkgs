{
  maven,
  lib,
  fetchFromGitHub,
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

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-config-cli.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/adorsys/keycloak-config-cli/";
    description = "Import YAML/JSON-formatted configuration files into Keycloak";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jefferyoo
      anish
    ];
  };
}
