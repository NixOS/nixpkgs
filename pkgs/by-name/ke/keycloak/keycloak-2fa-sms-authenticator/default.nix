{
  stdenv,
  maven,
  lib,
  fetchFromGitHub,
}:
maven.buildMavenPackage rec {
  pname = "keycloak-2fa-sms-authenticator";
  version = "26.4.10";

  src = fetchFromGitHub {
    owner = "netzbegruenung";
    repo = "keycloak-mfa-plugins";
    tag = "v${version}";
    hash = "sha256-J7t/SRfK/LTcW7Y+D6bkHcXK+lKqUYLEqSpNWJUC3kQ=";
  };

  mvnHash =
    let
      mvnHashes = {
        "aarch64-darwin" = "sha256-eRlu24SYe+PBOTKoAQPd5MoM7VUxHZx4/uiW6mV2PZI=";
        "x86_64-darwin" = "sha256-p+XpCjXiEPMJnXIrbD2Qse/csZfv8YZ6h+sNZitCyro=";
        "aarch64-linux" = "sha256-4P9qM3X99dEy3ssr1+vp65QUJikRfE4EoK6LOta9IFs=";
        "x86_64-linux" = "sha256-wxgEHC1xJahyoizozvRfRZAWTjrYmYNM42yk+ZRke5A=";
      };
    in
    mvnHashes.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  installPhase = ''
    runHook preInstall
    install -Dm644 sms-authenticator/target/netzbegruenung.sms-authenticator-v${version}.jar \
      $out/keycloak-2fa-sms-authenticator.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/netzbegruenung/keycloak-mfa-plugins";
    description = "Keycloak authentication provider for 2FA via SMS";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anish ];
  };
}
