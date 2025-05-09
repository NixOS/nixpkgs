{
  buildNpmPackage,
  nodejs,

  legendsviewer-next,
}:
buildNpmPackage rec {
  pname = "legends-viewer-frontend";
  version = legendsviewer-next.version;

  npmDepsHash = "sha256-pnhjGlss8U18fK4VKCPiM9kKhmUaJMMBcDOqA/Bexj4=";

  src = "${legendsviewer-next.src}/LegendsViewer.Frontend/${pname}";

  inherit nodejs;

  installPhase = ''
    mkdir -p $out
    cp -r ./dist $out
  '';
}
