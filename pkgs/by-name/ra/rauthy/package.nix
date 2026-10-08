{
  lib,
  fetchFromGitHub,
  fetchurl,
  fetchNpmDeps,
  rustPlatform,
  npmHooks,
  nodejs,
  nix-update-script,
  perl,
  wasm-pack,
  wasm-bindgen-cli_0_2_129,
  binaryen,
  lld,
  rust-jemalloc-sys-unprefixed,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rauthy";
  version = "0.37.1";

  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q++LR9ojdpsn/fAbGnOOxz+auZb9u6TVaM750X8f1gc=";
  };

  nativeBuildInputs = [
    binaryen
    lld
    nodejs
    npmHooks.npmConfigHook
    perl
    wasm-bindgen-cli_0_2_129
    wasm-pack
  ];

  buildInputs = [ rust-jemalloc-sys-unprefixed ];

  npmRoot = "frontend";

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/frontend";
    hash = "sha256-BDXHpgQ0IXo+6EZv8AkclXOtwgYZl5F2u9xaHIrbc8s=";
  };

  cargoHash = "sha256-uqJAfYL62R4GaDszaNloP3h1FNXZkxZfLAGBJk5zLmE=";

  fidoMdsBlob = fetchurl {
    name = "fido-mds-290.jwt";
    url = "https://mds.fidoalliance.org/";
    hash = "sha256-6LybO7BuGJMRht2pbZkm9T5FnHxHRj+6GrQwiRERABM=";
  };

  preBuild = ''
    pushd src/wasm-modules
    wasm-pack build -d ../../frontend/src/wasm/spow --no-pack --out-name spow --features spow
    wasm-pack build -d ../../frontend/src/wasm/md --no-pack --out-name md --features md
    popd
    pushd "$npmRoot"
    npm run build
    popd

    # The release build embeds this dataset. Bootstrap the upstream prep tool
    # in debug mode and transform the pinned blob without network access.
    cargo run --offline --locked --jobs "$NIX_BUILD_CORES" --bin fido-mds-prep -- \
      --source ${finalAttrs.fidoMdsBlob} --out assets/fido_mds/dataset.bin
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
    changelog = "https://github.com/sebadob/rauthy/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      angelodlfrtr
      ungeskriptet
    ];
  };
})
