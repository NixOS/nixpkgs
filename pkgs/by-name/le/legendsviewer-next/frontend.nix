{
  version,
  src,
  patches,

  lib,
  nodejs_22,

  buildNpmPackage,
}:
buildNpmPackage {
  pname = "legends-viewer-frontend";

  inherit version src patches;

  nodejs = nodejs_22;
  npmDepsHash = "sha256-pnhjGlss8U18fK4VKCPiM9kKhmUaJMMBcDOqA/Bexj4=";

  postPatch = ''
    cd "./LegendsViewer.Frontend/legends-viewer-frontend"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./dist $out

    runHook postInstall
  '';

  meta = {
    description = "Recreates Dwarf Fortress' Legends Mode from exported files";
    homepage = "https://github.com/Kromtec/LegendsViewer-Next";
    license = lib.licenses.mit;
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ donottellmetonottellyou ];
  };
}
