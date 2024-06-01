{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cat9";
  version = "unstable-2023-06-01";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "cat9";
    rev = "a34da77d186163b886049c7d85e812200b80d83d";
    hash = "sha256-DEEbWyEi/Ba7bXWkjRQR4aG/uZSGz5lN5eaDy8TeWRA=";
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
