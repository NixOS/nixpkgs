{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  cargo,
  cmake,
  makeBinaryWrapper,
  nodejs-slim,
  pnpmConfigHook,
  pnpm_10,
  rustPlatform,
  rustc,
  versionCheckHook,
}:

# Build with pnpm instead of buildRustPackage because Prettier integration
# requires the JavaScript runtime and npm dependencies.
# A pure Rust build would lack the Prettier plugin functionality.
stdenv.mkDerivation (finalAttrs: {
  pname = "oxfmt";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "oxc";
    tag = "oxfmt_v${finalAttrs.version}";
    hash = "sha256-AatmbW8UE8UbV533I2nhijHNlqIsgvtlE7X98uT7aTA=";
  };

  # Remove patchedDependencies from both workspace and lockfile
  # to avoid LOCKFILE_CONFIG_MISMATCH error
  postPatch = ''
    substituteInPlace pnpm-workspace.yaml pnpm-lock.yaml \
      --replace-fail "patchedDependencies:" "_patchedDependencies:"
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-4G52/8WZgNFM/vcHXBbtWabBZwWo3ZBVadFjOI2SmUk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 2;
    hash = "sha256-Do2sFEK/8Axj9B9M/W9zqMboPrAo5Zm/zdrMXZvmFg0=";
    prePnpmInstall = finalAttrs.postPatch;
  };

  nativeBuildInputs = [
    cargo
    cmake
    makeBinaryWrapper
    nodejs-slim
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
