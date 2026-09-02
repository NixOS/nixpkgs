{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  gnutar,
  makeBinaryWrapper,
  yarn-berry_4,
  nodejsInstallManuals,
  nodejsInstallExecutables,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gitbeaker-cli";
  version = "43.8.0";

  src = fetchFromGitHub {
    owner = "jdalrymple";
    repo = "gitbeaker";
    tag = finalAttrs.version;
    hash = "sha256-EVxDUEuxCnMiqqsKFs9JpRVJ86d9hW22K4a4we8eoJA=";
  };

  patches = [
    # Remove this when updating since upstream migrated to pnpm
    # https://github.com/jdalrymple/gitbeaker/blob/main/package.json#L59
    ./yarn-4.14-support.patch
  ];

  # Set for the `nodejsInstall` hooks
  npmWorkspace = "@gitbeaker/cli";

  nativeBuildInputs = [
    nodejs
    yarn-berry_4.yarnBerryConfigHook
    yarn-berry_4
    makeBinaryWrapper
    gnutar
    nodejsInstallManuals
    nodejsInstallExecutables
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes patches;
    hash = "sha256-RTgdHicbfbJbToif51TchLCfdIPZynvT0n/KwrydLYU=";
  };

  buildPhase = ''
    runHook preBuild

    yarn workspaces foreach -Rpt --from '@gitbeaker/*' run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib/node_modules/@gitbeaker/cli
    export yarnTmpDir=$(mktemp -d)
    export yarnPack=$yarnTmpDir/yarn-pack.tgz
    export packageRoot=$out/lib/node_modules/@gitbeaker
    export nodeModPath=$out/lib/node_modules/@gitbeaker/cli/node_modules

    # Basically yarnInstallHook
    pushd packages
    cp -r ./* "$packageRoot"/
    pushd cli
    nodejsInstallExecutables ./package.json
    nodejsInstallManuals ./package.json
    popd
    popd
    yarn workspaces focus --production @gitbeaker/cli
    find node_modules -maxdepth 1 -type d -empty -delete
    rm -rf node_modules/.bin
    cp -r ./node_modules $nodeModPath
    pushd $packageRoot
    ln -s $nodeModPath core/node_modules
    ln -s $nodeModPath requester-utils/node_modules
    ln -s $nodeModPath rest/node_modules
    popd
    unlink $nodeModPath/@gitbeaker/cli
    unlink $nodeModPath/@gitbeaker/core
    unlink $nodeModPath/@gitbeaker/requester-utils
    unlink $nodeModPath/@gitbeaker/rest
    rm -rrf $nodeModPath/@gitbeaker
    ln -s $packageRoot $nodeModPath

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/jdalrymple/gitbeaker/releases/tag/${finalAttrs.version}";
    description = "CLI Wrapper for the @gitbeaker/rest SDK";
    homepage = "https://github.com/jdalrymple/gitbeaker";
    maintainers = [ ];
    mainProgram = "gitbeaker";
  };
})
