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
  version = "0.68.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "oxc";
    tag = "oxfmt_v${finalAttrs.version}";
    hash = "sha256-BqBI+xOFDcsw4muiyh6TypA8msJfwTsQ/nC4B6AtiLE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-1raDjWN2IvtschMmLgs9Twlxc4+XVIEZ+7pqkVUDOR8=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-A4HpPjyL5UTMlpQ7hT/f2zbbW3GOKBFXWpZNdPRM6/s=";
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

  # @napi-rs/cli >= 3.8 reads the process start time and machine identity via
  # host binaries while acquiring its filesystem reconciliation lock. The
  # Darwin build sandbox denies those execs; Node raises them as synchronous
  # `spawn EPERM` from execFile, which escapes napi's callback-based error
  # handling. Point the lookups at a store no-op so the sandbox allows them.
  # Empty output is treated as unverifiable identity and only disables stale
  # lock detection.
  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for cli in node_modules/.pnpm/@napi-rs+cli@*/node_modules/@napi-rs/cli/dist/cli.js; do
      substituteInPlace "$cli" \
        --replace-fail '"/bin/ps"' '":"' \
        --replace-fail '"/usr/sbin/ioreg"' '":"' \
        --replace-fail '"/usr/sbin/sysctl"' '":"'
    done
  '';

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
    description = "High-performance formatter for the JavaScript ecosystem";
    homepage = "https://oxc.rs/docs/guide/usage/formatter";
    downloadPage = "https://github.com/oxc-project/oxc";
    changelog = "https://github.com/oxc-project/oxc/blob/${finalAttrs.src.tag}/apps/oxfmt/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "oxfmt";
    inherit (nodejs-slim.meta) platforms;
  };
})
