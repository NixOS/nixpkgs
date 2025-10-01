{
  lib,
  immich,
  jq,
  nodejs,
  makeWrapper,
  stdenv,
}:

let
  inherit (immich) pnpm;
in
stdenv.mkDerivation rec {
  pname = "immich-cli";
  version = "2.2.95";
  inherit (immich) src pnpmDeps;

  postPatch = ''
    local -r cli_version="$(jq -r .version cli/package.json)"
    test "$cli_version" = ${version} \
      || (echo "error: update immich-cli version to $cli_version" && exit 1)
  '';

  nativeBuildInputs = [
    jq
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

    local -r packageOut="$out/lib/node_modules/@immich/cli"

    pnpm --filter @immich/cli deploy --prod --no-optional "$packageOut"

    makeWrapper '${lib.getExe nodejs}' "$out/bin/immich" \
      --add-flags "$packageOut/dist/index.js"

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
