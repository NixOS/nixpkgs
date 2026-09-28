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
  wasm-bindgen-cli_0_2_126,
  binaryen,
  lld,
  rust-jemalloc-sys-unprefixed,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rauthy";
  version = "0.36.2";

  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G+7fCkG1omdFgbmZDYGPiQTWCvcHtui+Fv0dXXzuJ08=";
  };

  nativeBuildInputs = [
    binaryen
    lld
    nodejs
    npmHooks.npmConfigHook
    perl
    wasm-bindgen-cli_0_2_126
    wasm-pack
  ];

  buildInputs = [ rust-jemalloc-sys-unprefixed ];

  npmRoot = "frontend";

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/frontend";
    hash = "sha256-mDJMETAasMXIH9yCh2zfeaPNQUaYlHjxz8jDf7LySaY=";
  };

  cargoHash = "sha256-VPavc79U8AFhctktJ2Z2M75zguTGz7fhJGtMPXLqIgQ=";

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
