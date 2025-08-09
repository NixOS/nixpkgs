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
  cmake,

  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "sqld";
  version = "0.24.32";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "libsql";
    tag = "libsql-server-v${version}";
    hash = "sha256-CiTJ9jLANBrncz/O/0k2/UI/qGCTGWLZuLQdncunlX8";
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

  cargoHash = "sha256-4Ma/17t+EmmjiYICBLhJifQez0dnwtjhlkmoQrAIG+s";

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
  ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  # error[E0425]: cannot find function `consume_budget` in module `tokio::task`
  env.RUSTFLAGS = "--cfg tokio_unstable";

  # requires a complex setup with podman for the end-to-end tests
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "LibSQL with extended capabilities like HTTP protocol, replication, and more";
    homepage = "https://github.com/tursodatabase/libsql";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "sqld";
  };
}
