{
  version,
  src,
  patches,

  nodejs_22,

  buildNpmPackage,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "legends-viewer-frontend";

  inherit version src patches;

  nodejs = nodejs_22;
  npmDepsHash = "sha256-pnhjGlss8U18fK4VKCPiM9kKhmUaJMMBcDOqA/Bexj4=";

  postPatch = ''
    cd "./LegendsViewer.Frontend/${pname}"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
}
