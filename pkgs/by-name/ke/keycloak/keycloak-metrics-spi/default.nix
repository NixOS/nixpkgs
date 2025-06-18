{
  maven,
  lib,
  fetchFromGitHub,
}:

maven.buildMavenPackage rec {
  pname = "keycloak-metrics-spi";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "aerogear";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-MMonBRau8FpfCqija6NEdvp4zJfEub2Kwk4MA7FYWHI=";
  };

  mvnHash = "sha256-u+UAbKDqtlBEwrzh6LRgs8sZfMZ1u2TAluzOxsBrb/k=";

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
