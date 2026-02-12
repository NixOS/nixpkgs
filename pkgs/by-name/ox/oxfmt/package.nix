{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  cargo,
  cmake,
  makeBinaryWrapper,
  nodejs_24,
  nodejs-slim,
  pnpmConfigHook,
  pnpm_10,
  rustPlatform,
  rustc,
  versionCheckHook,
  nix-update-script,
}:

# Build with pnpm instead of buildRustPackage because Prettier integration
# requires the JavaScript runtime and npm dependencies.
# A pure Rust build would lack the Prettier plugin functionality.
stdenv.mkDerivation (finalAttrs: {
  pname = "oxfmt";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "oxc";
    tag = "oxfmt_v${finalAttrs.version}";
    hash = "sha256-EAM1DxA/TqnIRN5Tlvg5/jvbyOUtSuwQ4RCBeO9esCw=";
  };

  # Remove patchedDependencies from both workspace and lockfile
  # to avoid LOCKFILE_CONFIG_MISMATCH error
  postPatch = ''
    substituteInPlace pnpm-workspace.yaml pnpm-lock.yaml \
      --replace-fail "patchedDependencies:" "_patchedDependencies:"
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-okwkhcT6mekIvo52T8eSrXUcp/LQhcEYvHyIc5CLdrE=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 2;
    hash = "sha256-GOsSTfM93VgGhVlgzXhJIJG9MSf306cEnRru/aTA+oY=";
    prePnpmInstall = finalAttrs.postPatch;
  };

  nativeBuildInputs = [
    cargo
    cmake
    makeBinaryWrapper
    nodejs_24
    pnpmConfigHook
    pnpm_10
    rustPlatform.cargoSetupHook
    rustc
  ];

  # cmake is only needed for libmimalloc-sys2 crate, not for top-level build
  dontUseCmakeConfigure = true;

  env.OXC_VERSION = finalAttrs.version;

  buildPhase = ''
    runHook preBuild

    pnpm --filter oxfmt-app run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    local outPath=$out/lib/oxfmt
    mkdir -p $outPath $out/bin

    # Reinstall production dependencies only
    find -name 'node_modules' -type d -exec rm -rf {} \; || true
    pnpm --filter oxfmt-app install --offline --prod --ignore-scripts

    cp -r apps/oxfmt/dist $outPath/
    cp -rL apps/oxfmt/node_modules $outPath/
    cp npm/oxfmt/configuration_schema.json $outPath/

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/oxfmt \
      --add-flags $outPath/dist/cli.js

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^oxfmt_v([0-9.]+)$" ];
  };

  meta = {
    description = "JavaScript formatter with Prettier integration";
    homepage = "https://github.com/oxc-project/oxc";
    changelog = "https://github.com/oxc-project/oxc/blob/${finalAttrs.src.tag}/apps/oxfmt/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "oxfmt";
    inherit (nodejs-slim.meta) platforms;
  };
})
