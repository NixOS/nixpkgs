{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "apify-cli";
  version = "1.12.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "apify";
    repo = "apify-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T58AfsEd+YnWUpTeKMaFTRgGmQ72uI/hyyfjDZadgZM=";
  };

  # The workspace also has the docs website, which the CLI does not need.
  pnpmWorkspaces = [ "apify-cli" ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-VhmLbNrtkdiCZev/TWFTG21s0jxIMkW12YGmgVrPE2k=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_12
    pnpmConfigHook
    makeWrapper
  ];

  # With strictDeps, patchShebangs only uses buildInputs.
  buildInputs = [ nodejs ];

  # Upstream fills these in with `git rev-parse`, which needs the git history.
  postPatch = ''
    substituteInPlace src/lib/hooks/useCLIMetadata.ts \
      --replace-fail ' = DEVELOPMENT_VERSION_MARKER;' ' = "${finalAttrs.version}";' \
      --replace-fail ' = DEVELOPMENT_HASH_MARKER;' ' = "${finalAttrs.src.tag}";'
  '';

  buildPhase = ''
    runHook preBuild
    pnpm exec tsc
    pnpm exec tsdown
    runHook postBuild
  '';

  # `pnpm prune --prod` tries to reach the network, so reinstall only the runtime dependencies.
  installPhase = ''
    runHook preInstall
    rm -rf node_modules
    pnpm install --offline --prod --ignore-scripts --frozen-lockfile --filter=apify-cli
    # These pnpm state files contain timestamps and break reproducibility.
    rm node_modules/.modules.yaml node_modules/.pnpm-workspace-state-v1.json
    mkdir -p $out/lib/apify-cli $out/bin
    cp -r dist skills node_modules package.json $out/lib/apify-cli/
    # The CLI's update notice tells users to update with npm.
    for bin in apify actor; do
      makeWrapper ${lib.getExe nodejs} $out/bin/$bin \
        --add-flags $out/lib/apify-cli/dist/$bin.js \
        --set-default APIFY_CLI_SKIP_UPDATE_CHECK 1
    done
    ln -s apify $out/bin/apify-cli
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  # When the keyring module fails to load, the CLI silently stores the token in a plain file.
  postInstallCheck = ''
    export HOME=$(mktemp -d) APIFY_CLI_DISABLE_TELEMETRY=1
    (cd $HOME && $out/bin/apify init -y testing-actor && test -f .actor/actor.json)
    (cd $out/lib/apify-cli && ${lib.getExe nodejs} -e "require('@napi-rs/keyring')")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line interface for the Apify platform";
    homepage = "https://docs.apify.com/cli";
    changelog = "https://github.com/apify/apify-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "apify";
    inherit (nodejs.meta) platforms;
    maintainers = with lib.maintainers; [ artogahr ];
  };
})
