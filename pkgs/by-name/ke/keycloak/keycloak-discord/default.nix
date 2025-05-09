{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "keycloak-discord";
  version = "0.6.1";

  src = fetchurl {
    url = "https://github.com/wadahiro/keycloak-discord/releases/download/v${version}/keycloak-discord-${version}.jar";
    hash = "sha256-rz+YKV8oiYy+iuwrW0F01gOKuRt0w7FOkxMhFCbzNvs=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 "$src" "$out/keycloak-discord-$version.jar"
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/wadahiro/keycloak-discord";
    description = "Keycloak Social Login extension for Discord";
    license = licenses.asl20;
    maintainers = with maintainers; [ mkg20001 ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
