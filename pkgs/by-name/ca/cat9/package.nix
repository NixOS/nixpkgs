{
  lib,
  fetchfossil,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cat9";
  version = "0-unstable-2025-08-17";

  src = fetchfossil {
    url = "https://chiselapp.com/user/letoram/repository/cat9";
    rev = "459b0141c2e0f2b0d085952f618accb3a9cf455e8714be39f144b1c9dfa1b8b6";
    hash = "sha256-w+EOl49Cc6I+/i3TSNpbKjT9a2gXbop0YEu/eRckV+M=";
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
    description = "User shell for LASH";
    license = with lib.licenses; [ unlicense ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
