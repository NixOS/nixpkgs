{
  lib,
  fetchurl,
  fetchFromGitHub,
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
  version = "0.37.2";

  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PtRj5WJafeZXbYKaUL0QL6FuNL8E+Yw4Rk+efqB8r0w=";
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
    hash = "sha256-JXToq/nJQx7X0MzvzbNmuOYQFEFN2Ry2xQKSQwTwYWg=";
  };

  cargoHash = "sha256-Mk5Z/X/fdsT4Wyyb83zMiT5/WXIUOcpXPwdVPB3VMt8=";

  # Fetch the FIDO MDS blob from archive.org as it's otherwise unversioned and heavily ratelimited.
  fidoMdsBlob = fetchurl {
    url = "https://web.archive.org/web/20260907230546/https://mds.fidoalliance.org/";
    hash = "sha256-3bbeK2LzurqZC9MS0JHKUzueoZ2u+MXTyt+1SGCQCn4=";
  };

  preBuild = ''
    pushd src/wasm-modules
    wasm-pack build -d ../../frontend/src/wasm/spow --no-pack --out-name spow --features spow
    wasm-pack build -d ../../frontend/src/wasm/md --no-pack --out-name md --features md
    popd
    pushd "$npmRoot"
    npm run build
    popd
    # This is embedded in the release binary, so we build it from the fetched blob.
    # Tool built with the debug profile to match upstream.
    cargo run --offline --locked --jobs "$NIX_BUILD_CORES" --profile dev --bin fido-mds-prep -- \
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
    changelog = "https://github.com/sebadob/rauthy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      angelodlfrtr
      ungeskriptet
      asleepyskye
    ];
  };
})
