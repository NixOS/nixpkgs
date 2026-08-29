{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  gnutar,
  makeBinaryWrapper,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gitbeaker-cli";
  version = "44.0.0-pre.0";

  src = fetchFromGitHub {
    owner = "jdalrymple";
    repo = "gitbeaker";
    tag = "@gitbeaker/cli@${finalAttrs.version}";
    hash = "sha256-1YFrvQSLtznjtGeOjBd7bZfOsGDITejpWAZ+KubQiTk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-6DX20bHRWX3F6w2Gat5AvzLB/L6W5YSuqo+7v8t6MSI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeBinaryWrapper
    gnutar
  ];

  missingHashes = ./missing-hashes.json;

  buildPhase = ''
    runHook preBuild

    pnpm --filter "@gitbeaker/*..." build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    CI=true pnpm --ignore-scripts --prod prune

    # Remove non-deterministic files
    rm node_modules/{.modules.yaml,.pnpm-workspace-state-v1.json}

    mkdir -p $out/bin
    mkdir -p $out/lib
    mv packages $out/lib/packages
    mv node_modules/ $out/lib/node_modules

    runHook postInstall
  '';

  postFixup = ''
    chmod +x $out/lib/packages/cli/dist/index.mjs
    patchShebangs $out/lib/packages/cli/dist/index.mjs

    makeWrapper $out/lib/packages/cli/dist/index.mjs $out/bin/gb \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]}

    ln -s $out/bin/gb $out/bin/gitbeaker
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
