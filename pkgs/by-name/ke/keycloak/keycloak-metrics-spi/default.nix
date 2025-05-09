{
  maven,
  lib,
  fetchFromGitHub,
}:

maven.buildMavenPackage rec {
  pname = "keycloak-metrics-spi";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "aerogear";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-C6ueYhSMVMGpjHF5QQj9jfaS9sGTZ3wKZq2xmNgTmAg=";
  };

  mvnHash = "sha256-oHMkzXHR4mETH6VsxhFuap3AcjvTXytNkKlLY/mzT3g=";

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-metrics-spi-*.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/aerogear/keycloak-metrics-spi";
    description = "Keycloak Service Provider that adds a metrics endpoint";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.linux;
  };
}
