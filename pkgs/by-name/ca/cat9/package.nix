{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cat9";
  version = "unstable-2023-11-06";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "cat9";
    rev = "a807776a85237ab0bdd0a712fb33c176fc295e30";
    hash = "sha256-OlH8FgVBk76Qw+5mnsrryXOL9GbPJWlwUGtYlLuAPxQ=";
  };

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${placeholder "out"}/share/arcan/appl/cat9
    cp -a ./* ${placeholder "out"}/share/arcan/appl/cat9

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/letoram/cat9";
    description = "A User shell for LASH";
    license = with lib.licenses; [ unlicense ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
