{
  lib,
  immich,
  buildNpmPackage,
  nodejs,
  makeWrapper,
}:
buildNpmPackage {
  pname = "immich-cli";
  src = "${immich.src}/cli";
  inherit (immich.sources.components.cli) version npmDepsHash;

  nativeBuildInputs = [ makeWrapper ];

  inherit (immich.web) preBuild;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv package.json package-lock.json node_modules dist $out/

    makeWrapper ${lib.getExe nodejs} $out/bin/immich --add-flags $out/dist/index.js

    runHook postInstall
  '';

  meta = {
    description = "Self-hosted photo and video backup solution (command line interface)";
    homepage = "https://immich.app/docs/features/command-line-interface";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jvanbruegge ];
    inherit (nodejs.meta) platforms;
    mainProgram = "immich";
  };
}
