{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs-slim_24,
  rustPlatform,
  cargo,
  rustc,
  cmake,
  nix-update-script,
  version ? "1.2.15",
}:
let
  pnpm = pnpm_10.override { nodejs-slim = nodejs-slim_24; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rolldown";
  # Default from top-level; .override { version = "..." } replaces this via merge, and src/cargoDeps/pnpmDeps use finalAttrs.version below.
  version = version;

  # To obtain hashes: use `nix store prefetch-file --unpack <url>` for source; set hash = "" and build for cargoDeps/pnpmDeps.
  src = fetchFromGitHub {
    owner = "rolldown";
    repo = "rolldown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fGPH+Fxumvw2H45VCum/tbEVf8n3bqWlxn7Iob21C3g=";
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    pname = "rolldown";
    version = finalAttrs.version;
    src = finalAttrs.src;
    hash = "sha256-PrMdwMyxly/O5PQGDlP8/albwEKuaylp+UHFrSC9jpc=";
  };
  pnpmDeps = fetchPnpmDeps {
    pname = "rolldown";
    version = finalAttrs.version;
    src = finalAttrs.src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-2zeCf7ALI0+lDCoiOmkXVTtGjx0soMv0xb5QNOj6x4o=";
  };

  # cmake is only needed for Rust build (mimalloc-sys), not for a top-level configure
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm
    nodejs-slim_24
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cmake
  ];

  preBuild = ''
    # On darwin, @napi-rs/cli probes process identity via /bin/ps, ioreg and sysctl.
    # The sandbox makes spawn throw EPERM synchronously, bypassing its null fallback.
    for f in node_modules/.pnpm/@napi-rs+cli@*/node_modules/@napi-rs/cli/dist/{index.js,index.cjs,cli.js}; do
      chmod u+w "$f"
      substituteInPlace "$f" --replace-fail \
        'function executeProcessIncarnationCommand(' \
        'function executeProcessIncarnationCommand(...a) { return executeProcessIncarnationCommandUnsafe(...a).catch(() => null); }
    function executeProcessIncarnationCommandUnsafe('
    done
  '';

  buildPhase = ''
    runHook preBuild

    pnpm run --filter rolldown build-native:release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    local -r nodeModules="$out/lib/node_modules"
    mkdir -p "$nodeModules"

    # Install rolldown package
    local -r outPath="$nodeModules/rolldown"
    mkdir -p "$outPath"
    cp packages/rolldown/package.json "$outPath/"
    for d in bin cli dist; do
      [[ -d packages/rolldown/$d ]] && cp -r "packages/rolldown/$d" "$outPath/"
    done
    cp packages/rolldown/*.node "$outPath/" 2>/dev/null || true
    cp packages/rolldown/dist/*.node "$outPath/dist/" 2>/dev/null || true
    cp packages/rolldown/src/rolldown-binding.*.node "$outPath/dist/" 2>/dev/null || true

    # Install @rolldown/pluginutils (rolldown's runtime dependency, now published separately on npm)
    mkdir -p "$nodeModules/@rolldown"
    cp -rL packages/rolldown/node_modules/@rolldown/pluginutils "$nodeModules/@rolldown/pluginutils"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/rolldown/rolldown/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Fast Rust-based bundler for JavaScript";
    homepage = "https://github.com/rolldown/rolldown";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.chrisportela ];
    inherit (nodejs-slim_24.meta) platforms;
  };
})
