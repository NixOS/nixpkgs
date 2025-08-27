{
  lib,
  immich,
  nodejs,
  makeWrapper,
  stdenv,
}:

let
  inherit (immich) pnpm;
in
stdenv.mkDerivation {
  pname = "immich-cli";
  inherit (immich.sources.components.cli) version;
  inherit (immich) src pnpmDeps;

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm
    pnpm.configHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter @immich/sdk build
    pnpm --filter @immich/cli build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    pushd cli
    mv package.json node_modules dist $out/
    popd

    makeWrapper ${lib.getExe nodejs} $out/bin/immich --add-flags $out/dist/index.js

    runHook postInstall
  '';

  dontCheckForBrokenSymlinks = true;

  meta = {
    description = "Self-hosted photo and video backup solution (command line interface)";
    homepage = "https://immich.app/docs/features/command-line-interface";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jvanbruegge ];
    inherit (nodejs.meta) platforms;
    mainProgram = "immich";
  };
}
