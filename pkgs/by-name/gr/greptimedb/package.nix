{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  protobuf,
  zlib,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "greptimedb";
  version = "1.1.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "GreptimeTeam";
    repo = "greptimedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+Qb3cyvGrUhi3nBbEUoG2jJyYHFcTSIg34E6ZiI+weY=";
  };

  cargoHash = "sha256-/Sj7TRPsJ2mP8Da2FUhL2+bl5seFFDuS7RqZ1DLTF2o=";

  # otel-arrow-rust regenerates its protos from a directory that sits outside the
  # crate, which cargo vendoring drops. Its generated sources are committed, so
  # the codegen is redundant.
  postPatch = ''
    for f in "$cargoDepsCopy"/source-git-*/otel-arrow-rust-*/build.rs; do
      echo 'fn main() {}' > "$f"
    done

    # std::sync::Exclusive was renamed after the nightly upstream pins
    substituteInPlace src/servers/src/postgres/auth_handler.rs \
      --replace-fail 'use std::sync::Exclusive;' 'use std::sync::SyncView as Exclusive;'

    # gRPC service futures nest deeper than the default query depth allows
    sed -i '1i #![recursion_limit = "512"]' src/frontend/src/lib.rs
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [ zlib ];

  # cmake is here only to build the vendored C sources of aws-lc-sys
  dontUseCmakeConfigure = true;

  env = {
    # rust-toolchain.toml pins nightly for the crates' feature gates
    RUSTC_BOOTSTRAP = 1;
    PROTOC = lib.getExe' protobuf "protoc";
    PROTOC_INCLUDE = "${protobuf}/include";
  };

  cargoBuildFlags = [
    "--package"
    "cmd"
  ];

  # the suite starts a real cluster and reaches object stores over the network
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unified observability database for metrics, logs and traces";
    homepage = "https://github.com/GreptimeTeam/greptimedb";
    changelog = "https://github.com/GreptimeTeam/greptimedb/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "greptime";
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
  };
})
