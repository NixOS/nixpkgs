{
  clang,
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  protobuf,
  python3,
  rocksdb,
  rustPlatform,
  rustc,
}:

let
  python = python3.withPackages (ps: [ ps.tomli-w ]);
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "subtensor";
  version = "438";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RaoFoundation";
    repo = "subtensor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZQxI3aBK1oHO6DAf0SePfLYy6AM+ADNC7wWXBMPFTSg=";
  };

  cargoHash = "sha256-qpheM5oLcLOexjnlZCpgJKbpb3OjUvu4Z/QHq27CkFU=";

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
    ${python.interpreter} ${./fix-vendor-path-deps.py} "$cargoDepsCopy"
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

  env =
    let
      inherit (rustc.llvmPackages) clang-unwrapped libclang;
      majorVersion = lib.versions.major clang-unwrapped.version;
      resourceDir = "${lib.getLib clang-unwrapped}/lib/clang/${majorVersion}";
      includeDir = "${lib.getLib libclang}/lib/clang/${majorVersion}/include";
    in
    {
      OPENSSL_NO_VENDOR = "1";
      PROTOC = "${protobuf}/bin/protoc";
      ROCKSDB_LIB_DIR = "${rocksdb}/lib";

      # wasm-builder compiles the runtime blob for wasm32v1-none, but cc-rs
      # inherits the nix-wrapped host gcc from $CC, which rejects wasm-only
      # flags such as -mmutable-globals. Point that target at an unwrapped
      # clang, which can target wasm
      CC_wasm32v1_none = lib.getExe clang-unwrapped;
      CFLAGS_wasm32v1_none = "-isystem ${includeDir} -resource-dir ${resourceDir}";
      WASM_BUILD_RUSTFLAGS = "-C link-arg=--allow-undefined";
    };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v(\\d+)" ];
  };

  meta = {
    description = "Bittensor blockchain layer (Subtensor node)";
    homepage = "https://github.com/RaoFoundation/subtensor";
    changelog = "https://github.com/RaoFoundation/subtensor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kilyanni ];
    mainProgram = "node-subtensor";
    platforms = lib.platforms.linux;
  };
})
