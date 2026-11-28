{
  lib,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rustPlatform,
  protobuf,
  stdenv,
  git,
}:

# Scholarsome needs prisma v4.15.0, which is not available on nixpkgs.
#
# Adapted from :
#   https://github.com/NixOS/nixpkgs/blob/29bcead8405cfe4c00085843eb372cc43837bb9d/pkgs/development/tools/database/prisma-engines/default.nix
rustPlatform.buildRustPackage {
  pname = "prisma-engines";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "prisma-engines";
    rev = "8fbc245156db7124f997f4cecdd8d1219e360944";
    hash = "sha256-9TSNO28e0kLFZ+/FnHT69VU6yzd4ATdmto7+u87YTHU=";
  };

  # Needed to bypass the `!#[deny(warnings)]` enforced by user-facing-errors v0.1.0,
  # otherwise the build will fail with :
  #   > error: use of deprecated type alias `std::panic::PanicInfo`: use `PanicHookInfo` instead
  env.RUSTFLAGS = "--cap-lints warn";

  # Use system openssl
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    git
  ];

  buildInputs = [
    openssl
    protobuf
  ];

  # Prevent IFD issues from `cargoLock.lockFile = "${src}/Cargo.lock"`
  cargoHash = "sha256-wzIINgpjHD7iLOPZsxYUNk2G1y8FxA5du4CJ2FtCrSs=";

  patches = [
    ./0001-prisma-rustc-ambiguous-name.patch # see https://github.com/prisma/prisma-engines/pull/4321#discussion_r1347878132
  ];

  # We won't need `prisma-fmt` nor the `query-engine`.
  cargoBuildFlags = [
    "-p"
    "query-engine-node-api"
    "-p"
    "schema-engine-cli"
    # The above actually produces the migration engine, it was being renamed at the time.
    # See : https://github.com/prisma/prisma-engines/blob/8fbc245156db7124f997f4cecdd8d1219e360944/schema-engine/cli/Cargo.toml#L32-L35
  ];

  preBuild = ''
    export OPENSSL_DIR=${lib.getDev openssl}
    export OPENSSL_LIB_DIR=${lib.getLib openssl}/lib

    export PROTOC=${protobuf}/bin/protoc
    export PROTOC_INCLUDE="${protobuf}/include";

    export SQLITE_MAX_VARIABLE_NUMBER=250000
    export SQLITE_MAX_EXPR_DEPTH=10000
  '';

  postInstall = ''
    mv $out/lib/libquery_engine${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libquery_engine.node
  '';

  doCheck = false;
}
