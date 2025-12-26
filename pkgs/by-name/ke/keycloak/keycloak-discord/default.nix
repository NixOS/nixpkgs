{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "keycloak-discord";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/wadahiro/keycloak-discord/releases/download/v${version}/keycloak-discord-${version}.jar";
    hash = "sha256-radvUu2a6t0lbo5f/ADqy7+I/ONXB7/8pk2d1BtYzQA=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 "$src" "$out/keycloak-discord-$version.jar"
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/wadahiro/keycloak-discord";
    description = "Keycloak Social Login extension for Discord";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mkg20001 ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
