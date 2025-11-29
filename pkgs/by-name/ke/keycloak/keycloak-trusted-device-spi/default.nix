{
  lib,
  fetchFromGitHub,
  maven,
}:

maven.buildMavenPackage rec {
  pname = "keycloak-spi-trusted-device";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "wouterh-dev";
    repo = "keycloak-spi-trusted-device";
    rev = "v${version}";
    hash = "sha256-3GFQsgFXDEN5ORO7rkHSlEcdCbnVR3V8byXsGXCd00o=";
  };

  mvnHash = "sha256-Gi7Wx9LI/Y4MprNJrMkhhJSIK/z2aVB4OpzZnD1+70I=";

  installPhase = ''
    install -D "spi/target/keycloak-spi-trusted-device-1.0-SNAPSHOT.jar" "$out/spi-trusted-device-${version}.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/wouterh-dev/keycloak-spi-trusted-device";
    description = "Third party module that adds OTP trusted device functionality to Keycloak";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ notthebee ];
  };
}
