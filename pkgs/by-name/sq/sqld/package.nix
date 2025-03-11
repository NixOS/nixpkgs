{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # https://github.com/tursodatabase/libsql/pull/1981
    # A CMakeLists.txt broke builds by forcing the '-msse4.2' and '-maes' x86-specific compile flags,
    # when compiling with Clang, regardless of the host platform's architecture.
    (fetchpatch {
      url = "https://github.com/tursodatabase/libsql/commit/5ce88e8cf9476ea64453bf1532d75c8faf037aad.patch";
      hash = "sha256-5M6XNp0EpCZMZb7NC7TBGBVdZLkC74vwqEnVTCZ7n5U=";
    })
  ];

  cargoBuildFlags = [
    "--bin"
    "sqld"
  ];

  cargoHash = "sha256-hjU1Sbs68qX+Vv01Lku063OT1Sp7EMVxLyUkzcriRc0=";
  useFetchCargoVendor = true;

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
