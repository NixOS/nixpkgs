{
  maven,
  lib,
  stdenv,
  fetchFromGitHub,
}:
maven.buildMavenPackage rec {
  pname = "keycloak-metrics-spi";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "aerogear";
    repo = "keycloak-metrics-spi";
    tag = version;
    hash = "sha256-C6ueYhSMVMGpjHF5QQj9jfaS9sGTZ3wKZq2xmNgTmAg=";
  };

  mvnHash =
    let
      mvnHashes = {
        "aarch64-darwin" = "sha256-L+LVJGBVhkaWOdXpHep9f2s7hLr3enf5POm8U+Y7I1w=";
        "x86_64-darwin" = "sha256-G/e0mgAGP+6zvX3b0EuI95bdLT7Bzwh1GgcAfxzsIhE=";
        "aarch64-linux" = "sha256-Nrs+gqRYPKXWRr0COAsKmOrNaza2fxhEAJ5x896tKvA=";
        "x86_64-linux" = "sha256-oHMkzXHR4mETH6VsxhFuap3AcjvTXytNkKlLY/mzT3g=";
      };
    in
    mvnHashes.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-metrics-spi-*.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/aerogear/keycloak-metrics-spi";
    description = "Keycloak Service Provider that adds a metrics endpoint";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      anish
    ];
  };
}
