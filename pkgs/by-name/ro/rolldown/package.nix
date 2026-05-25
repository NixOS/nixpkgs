{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs_22,
  rustPlatform,
  cargo,
  rustc,
  cmake,
  version ? "1.0.0-rc.12",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rolldown";
  # Default from top-level; .override { version = "..." } replaces this via merge, and src/cargoDeps/pnpmDeps use finalAttrs.version below.
  version = version;

  # To obtain hashes: use `nix store prefetch-file --unpack <url>` for source; set hash = "" and build for cargoDeps/pnpmDeps.
  src = fetchFromGitHub {
    owner = "rolldown";
    repo = "rolldown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G26fPJElnIob1b94KqM5b2A64qs+x/d8FNrAsaN8BOI=";
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    pname = "rolldown";
    version = finalAttrs.version;
    src = finalAttrs.src;
    hash = "sha256-btGnMU+t8zij/gRfFp5p6h2/781IZM5AWvZNqC2dfNs=";
  };
  pnpmDeps = fetchPnpmDeps {
    pname = "rolldown";
    version = finalAttrs.version;
    src = finalAttrs.src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-lQVbYV8S3P1+AQwF9PBDxJqbKf9jBAtwymKcxQ55FeQ=";
  };

  # cmake is only needed for Rust build (mimalloc-sys), not for a top-level configure
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_10
    nodejs_22
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cmake
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run --filter "@rolldown/pluginutils" build
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

    # Install @rolldown/pluginutils (rolldown's runtime dependency; only built output, no node_modules)
    mkdir -p "$nodeModules/@rolldown/pluginutils"
    cp packages/pluginutils/package.json "$nodeModules/@rolldown/pluginutils/"
    [[ -d packages/pluginutils/dist ]] && cp -r packages/pluginutils/dist "$nodeModules/@rolldown/pluginutils/"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/rolldown/rolldown/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Fast Rust-based bundler for JavaScript";
    homepage = "https://github.com/rolldown/rolldown";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.chrisportela ];
    inherit (nodejs_22.meta) platforms;
  };
})
