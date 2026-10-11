{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeWrapper,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "e2b";
  version = "2.18.2";

  src = fetchFromGitHub {
    owner = "e2b-dev";
    repo = "e2b";
    tag = "@e2b/cli@${finalAttrs.version}";
    hash = "sha256-MSPqzhKgINOO+DjN31kI/TdnmBn41Xs5lVdYdX7xl9M=";
  };

  # The CLI bundles the `e2b` SDK from the same workspace, so both need their dependencies.
  pnpmWorkspaces = [ "@e2b/cli..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-Qj9P+/t664WI3cMlpTvWzGO1aU9URHG5EikmIoHXbLg=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  strictDeps = true;
  __structuredAttrs = true;

  buildPhase = ''
    runHook preBuild

    pnpm --filter=@e2b/cli... run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    pnpm config set --location=project inject-workspace-packages true
    # A flat node_modules, like npm produces: the bundled SDK resolves undici at runtime.
    pnpm config set --location=project node-linker hoisted
    pnpm --filter=@e2b/cli --prod deploy $out/lib

    # pnpm deploy leaves state files with timestamps and build-directory paths
    # behind, and rewrites the `e2b` workspace dependency to such a path.
    rm -r $out/lib/node_modules/{.pnpm,.modules.yaml,.pnpm-workspace-state-v1.json} $out/lib/pnpm-lock.yaml
    cp packages/cli/package.json $out/lib/package.json

    # patchShebangs does not understand `env -S node ...`
    substituteInPlace $out/lib/dist/index.js \
      --replace-fail "#!/usr/bin/env -S node --enable-source-maps" "#!${lib.getExe nodejs} --enable-source-maps"

    # commander names the program after the script it was started with, so run
    # the entrypoint through a link called `e2b`, as the npm bin does.
    mkdir $out/lib/bin
    ln -s ../dist/index.js $out/lib/bin/e2b

    # The update notifier can only suggest an npm update.
    makeWrapper ${lib.getExe nodejs} $out/bin/e2b \
      --add-flags --enable-source-maps \
      --add-flags $out/lib/bin/e2b \
      --set NO_UPDATE_NOTIFIER 1

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=@e2b/cli@(.*)" ];
  };

  meta = {
    description = "CLI for managing E2B sandboxes and sandbox templates";
    homepage = "https://e2b.dev";
    changelog = "https://github.com/e2b-dev/e2b/blob/@e2b/cli@${finalAttrs.version}/packages/cli/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mishushakov ];
    mainProgram = "e2b";
  };
})
