{
  lib,
  immich,
  jq,
  nodejs,
  makeWrapper,
  runtimeShellPackage,
  stdenv,
  versionCheckHook,
  pnpmConfigHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "immich-cli";
  inherit (immich) version src pnpmDeps;

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = lib.optionalString (lib.versionOlder immich.version "3.0.0") ''
    local -r cli_version="$(jq -r .version cli/package.json)"
    test "$cli_version" = ${finalAttrs.version} \
      || (echo "error: update immich-cli version to $cli_version" && exit 1)
  '';

  nativeBuildInputs = [
    jq
    makeWrapper
    nodejs
    pnpmConfigHook
    immich.pnpm
  ];

  buildInputs = [
    runtimeShellPackage
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

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Self-hosted photo and video backup solution (command line interface)";
    homepage = "https://immich.app/docs/features/command-line-interface";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jvanbruegge ];
    inherit (nodejs.meta) platforms;
    mainProgram = "immich";
  };
})
