{
  clang,
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  protobuf,
  rocksdb,
  rustPlatform,
  rustc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "subtensor";
  version = "3.3.14-401";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "opentensor";
    repo = "subtensor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-btuV2YQ/TCRiYucpdcXOuM2E4CgR7WsFWoHXqbVjhYk=";
  };

  cargoHash = "sha256-bksIPV6wYl9FGa7D4qXs0pvgn9CF8tvE3MY2CkvNU+Q=";

  postPatch = ''
    # cargoSetupHook substitutes @vendor@ into a temp copy appended to the
    # source .cargo/config.toml, but leaves the vendor dir's own config.toml
    # unsubstituted. wasm-builder's child cargo reads that file directly,
    # so we need to manually do the substitution there
    substituteInPlace "$cargoDepsCopy/.cargo/config.toml" \
      --subst-var-by vendor "$cargoDepsCopy"

    # fetchCargoVendor does not rewrite intra-workspace path deps in vendored
    # git-source crates (unlike `cargo vendor`). Fix them so that
    # substrate-wasm-builder's fresh cargo invocation can resolve its deps
    bash ${./fix-vendor-path-deps.sh} "$cargoDepsCopy"
  '';

  cargoBuildFlags = [
    "-p"
    "node-subtensor"
  ];

  nativeBuildInputs = [
    clang
    pkg-config
    protobuf
    rustPlatform.bindgenHook
    rustc.llvmPackages.lld
  ];

  buildInputs = [
    openssl
    rocksdb
  ];

  env = {
    OPENSSL_NO_VENDOR = "1";
    PROTOC = "${protobuf}/bin/protoc";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v(.*)" ];
  };

  meta = {
    description = "Bittensor blockchain layer (Subtensor node)";
    homepage = "https://github.com/opentensor/subtensor";
    changelog = "https://github.com/opentensor/subtensor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ kilyanni ];
    mainProgram = "node-subtensor";
    platforms = lib.platforms.linux;
  };
})
