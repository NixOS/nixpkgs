{
  stdenv,
  maven,
  lib,
  fetchFromGitHub,
}:
maven.buildMavenPackage rec {
  pname = "keycloak-discord";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "wadahiro";
    repo = "keycloak-discord";
    tag = "v${version}";
    hash = "sha256-BA7x28k/aMI3VPQmEgNhKD9N34DdYqadAD/m4cxLSYg=";
  };

  mvnHash =
    let
      mvnHashes = {
        "aarch64-darwin" = "sha256-Or7VOZwz4NfDtb0kmHbbTYE/avAc+H8+Y6JPw+HGjxs=";
        "x86_64-darwin" = "sha256-sX10vYlb2hWArTLZsPTcKYHHsPffQKtBxpcI42wcZZA=";
        "aarch64-linux" = "sha256-I5qjhfAXPXMb+1SPG29t/IKH/zBQqdnu3U7dYSQhTL8=";
        "x86_64-linux" = "sha256-uhm++MGgTN32/xbHNd+Z3Hes9Q5tl8ztIQ92LxMWKjg=";
      };
    in
    mvnHashes.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-discord-${version}.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/wadahiro/keycloak-discord";
    description = "Keycloak Identity Provider extension for Discord";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mkg20001
      anish
    ];
  };
}
