{
  lib,
  src,
  immich,
  buildNpmPackage,
  nodejs,
  makeWrapper,
}:
let
  sources = lib.importJSON ./sources.json;
in
buildNpmPackage {
  pname = "immich-cli";
  inherit (sources) version;
  src = "${src}/cli";
  inherit (sources.components.cli) npmDepsHash;

  nativeBuildInputs = [ makeWrapper ];

  inherit (immich.web) preBuild;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv package.json package-lock.json node_modules dist $out/

    ls $out/dist

    makeWrapper ${lib.getExe nodejs} $out/bin/immich --add-flags $out/dist/index.js

    runHook postInstall
  '';

  meta = {
    description = "Self-hosted photo and video backup solution (command line interface)";
    homepage = "https://immich.app/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jvanbruegge ];
    inherit (nodejs.meta) platforms;
    mainProgram = "immich";
  };
}
