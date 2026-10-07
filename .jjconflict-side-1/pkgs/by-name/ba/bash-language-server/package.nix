{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs-slim,
  makeBinaryWrapper,
  shellcheck,
  versionCheckHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bash-language-server";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "bash-lsp";
    repo = "bash-language-server";
    tag = "server-${finalAttrs.version}";
    hash = "sha256-Rhdo+sew6xUzVy0S+upP5vvoIxL2NBA2j0euS6rdC7g=";
  };

  pnpmWorkspaces = [ "bash-language-server" ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_12;
    fetcherVersion = 4;
    hash = "sha256-NIoXHWxP26sz4WJ0zcG67sB8sr/FoEj06s2foc0hqNs=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpmConfigHook
    pnpm_12
    makeBinaryWrapper
    versionCheckHook
  ];
  buildPhase = ''
    runHook preBuild

    # Upstream's "compile" script is `tsc -b && cp server/src/get-options.sh
    # server/out/`. We can't just run `pnpm compile`, because `tsc -b` with
    # no project argument builds the root tsconfig.json, which references
    # both `server` and `vscode-client` - and the latter's dependencies
    # aren't installed here. So build only the `server` project explicitly,
    # and do the `cp` ourselves.
    pnpm exec tsc -b server
    cp server/src/get-options.sh server/out/

    runHook postBuild
  '';

  preInstall = ''
    # remove unnecessary files
    rm node_modules/.modules.yaml
    # `pnpm prune` doesn't support monorepos, and with pnpm 12 it also tries
    # to verify the lockfile against supply-chain policies over the network.
    # Reinstall production dependencies only instead, as `pnpm prune --help`
    # recommends for monorepos.
    rm -rf node_modules server/node_modules
    pnpm install \
      --offline \
      --ignore-scripts \
      --filter=bash-language-server \
      --frozen-lockfile \
      --prod
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
    makeWrapper ${lib.getExe nodejs-slim} $out/bin/bash-language-server \
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
