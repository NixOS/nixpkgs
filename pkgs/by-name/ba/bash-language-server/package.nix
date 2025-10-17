{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm_10,
  nodejs,
  makeBinaryWrapper,
  shellcheck,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bash-language-server";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "bash-lsp";
    repo = "bash-language-server";
    tag = "server-${finalAttrs.version}";
    hash = "sha256-Pe32lQSlyWcyUbqwhfoulwNwhrnWdRcKFIl3Jj0Skac=";
  };

  pnpmWorkspaces = [ "bash-language-server" ];
  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 1;
    hash = "sha256-NvyqPv5OKgZi3hW98Da8LhsYatmrzrPX8kLOfLr+BrI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
    makeBinaryWrapper
    versionCheckHook
  ];
  buildPhase = ''
    runHook preBuild

    pnpm compile server

    runHook postBuild
  '';

  preInstall = ''
    # remove unnecessary files
    rm node_modules/.modules.yaml
    CI=true pnpm --ignore-scripts --prod prune
    rm -r node_modules/.pnpm/@mixmark-io*/node_modules/@mixmark-io/domino/{test,.yarn}
    find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules server/node_modules -xtype l -delete

    # remove non-deterministic files
    rm node_modules/.modules.yaml
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/bash-language-server}
    cp -r {node_modules,server} $out/lib/bash-language-server/

    # Create the executable, based upon what happens in npmHooks.npmInstallHook
    makeWrapper ${lib.getExe nodejs} $out/bin/bash-language-server \
      --suffix PATH : ${lib.makeBinPath [ shellcheck ]} \
      --inherit-argv0 \
      --add-flags $out/lib/bash-language-server/server/out/cli.js

    runHook postInstall
  '';

  doInstallCheck = true;

  meta = {
    description = "Language server for Bash";
    homepage = "https://github.com/bash-lsp/bash-language-server";
    changelog = "https://github.com/bash-lsp/bash-language-server/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      doronbehar
      gepbird
    ];
    mainProgram = "bash-language-server";
    platforms = lib.platforms.all;
  };
})
