{
  lib,
  fetchFromCodeberg,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cat9";
  version = "0-unstable-2025-12-26";

  src = fetchFromCodeberg {
    owner = "letoram";
    repo = "cat9";
    rev = "8d2b30545c3e87c8f2e161d755b53c23a48bcf05";
    hash = "sha256-KSXfa7K8SxnyPmSNCXZs8C+gGYxkLRu0MFbJ3cotSEQ=";
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
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
