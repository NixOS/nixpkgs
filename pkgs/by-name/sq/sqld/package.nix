{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  openssl,
  sqlite,
  zstd,
  stdenv,
  darwin,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "sqld";
  version = "0.24.18";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "libsql";
    rev = "libsql-server-v${version}";
    hash = "sha256-/0Sk55GBjUk/FeIoq/hGVaNGB0EM8CxygAXZ+ufvWKg=";
  };

  cargoBuildFlags = [
    "--bin"
    "sqld"
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-hjU1Sbs68qX+Vv01Lku063OT1Sp7EMVxLyUkzcriRc0=";

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    sqlite
    zstd
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  # requires a complex setup with podman for the end-to-end tests
  doCheck = false;

  meta = {
    description = "LibSQL with extended capabilities like HTTP protocol, replication, and more";
    homepage = "https://github.com/tursodatabase/libsql";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
