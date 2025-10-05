{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

let
  version = "1.4.0";
in
buildNpmPackage {
  pname = "fediwall";
  inherit version;

  src = fetchFromGitHub {
    owner = "defnull";
    repo = "fediwall";
    tag = "v${version}";
    hash = "sha256-aEY6mO7Es+H6CNE4shj/jz47nUeEIxGijKbUscIp0pM=";
  };

  npmDepsHash = "sha256-0VQ/CBqpQNqjg3lug+AQfFVbh0KhEaGwd+cEakBr/Dc=";

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = {
    description = "Social media wall for the Fediverse";
    homepage = "https://fediwall.social";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ transcaffeine ];
  };
}
