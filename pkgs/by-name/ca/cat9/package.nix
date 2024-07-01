{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cat9";
  version = "0-unstable-2024-06-17";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "cat9";
    rev = "f00e8791c1826065d4a93ace12e55ab5732d17a7";
    hash = "sha256-xFw6r7SQK0T5j7hVK3U39U2Q/qZow6Ad/R0Cl6nqUQw=";
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
