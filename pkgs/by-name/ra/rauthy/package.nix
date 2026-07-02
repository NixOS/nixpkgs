{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  rustPlatform,
  npmHooks,
  nodejs,
  nix-update-script,
  perl,
  wasm-pack,
  wasm-bindgen-cli_0_2_121,
  binaryen,
  lld,
  rust-jemalloc-sys-unprefixed,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rauthy";
  version = "0.35.2";

  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-onwNtlz2FP01aYr/T3Y3KK3CJHKsBBOF6vCfWKrdyRE=";
  };

  nativeBuildInputs = [
    binaryen
    lld
    nodejs
    npmHooks.npmConfigHook
    perl
    wasm-bindgen-cli_0_2_121
    wasm-pack
  ];

  buildInputs = [ rust-jemalloc-sys-unprefixed ];

  npmRoot = "frontend";

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/frontend";
    hash = "sha256-w3x+dUfmJ4H82wX87C3UHEJ5Ls4v6lsn7kKOxvRJY8g=";
  };

  cargoHash = "sha256-oUc8aMsI3i0WM5/tP/ro93GgkjaDjBdYcgpxiKDvtJ4=";

  preBuild = ''
    pushd src/wasm-modules
    wasm-pack build -d ../../frontend/src/wasm/spow --no-pack --out-name spow --features spow
    wasm-pack build -d ../../frontend/src/wasm/md --no-pack --out-name md --features md
    popd
    pushd "$npmRoot"
    npm run build
    popd
  '';

  # Tests fail and appear unmaintained upstream.
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    mainProgram = "rauthy";
    description = "Single Sign-On Identity & Access Management via OpenID Connect, OAuth 2.0 and PAM";
    homepage = "https://github.com/sebadob/rauthy";
    changelog = "https://github.com/sebadob/rauthy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      angelodlfrtr
      ungeskriptet
    ];
  };
})
