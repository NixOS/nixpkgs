{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mcpc";
  version = "0.7.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "apify";
    repo = "mcpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4Xh78DH6yTAt6L4ePM9E7cbiNuYRK2wzRZuB5edpM+E=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 5;
    hash = "sha256-mIKFuS2FLmRpQNXzaPWwl/OiJ/wgjlezVQFmcq7o9UQ=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
    makeWrapper
  ];

  buildInputs = [ nodejs ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  # `pnpm prune --prod` tries to reach the network, so reinstall only the runtime dependencies.
  installPhase = ''
    runHook preInstall
    rm -rf node_modules
    pnpm install --offline --prod --ignore-scripts --frozen-lockfile
    # These pnpm state files contain timestamps and break reproducibility.
    rm node_modules/.modules.yaml node_modules/.pnpm-workspace-state-v1.json
    mkdir -p $out/lib/mcpc $out/bin
    cp -r bin dist skills node_modules package.json $out/lib/mcpc/
    for bin in mcpc mcpc-bridge; do
      makeWrapper ${lib.getExe nodejs} $out/bin/$bin --add-flags $out/lib/mcpc/bin/$bin
    done
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  # When the keyring module fails to load, mcpc silently stores credentials in a plain file.
  postInstallCheck = ''
    (cd $out/lib/mcpc && ${lib.getExe nodejs} -e "require('@napi-rs/keyring')")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line client for the Model Context Protocol (MCP)";
    homepage = "https://github.com/apify/mcpc";
    changelog = "https://github.com/apify/mcpc/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "mcpc";
    inherit (nodejs.meta) platforms;
    maintainers = with lib.maintainers; [ artogahr ];
  };
})
