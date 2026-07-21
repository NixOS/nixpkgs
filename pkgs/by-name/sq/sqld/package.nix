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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sqld";
  version = "0.24.33";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "libsql";
    tag = "libsql-server-v${finalAttrs.version}";
    hash = "sha256-ufpYZdw/96QIQ43ex4FTA/aulouZPDkbmSt7X4YnEzo=";
  };

  patches = [ ];

  cargoBuildFlags = [
    "--bin"
    "sqld"
  ];

  cargoHash = "sha256-n2STJfX1sEeSbr3v9xst3S7UgLrUIdqfokqlHLWCVzY=";

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

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;

    # error[E0425]: cannot find function `consume_budget` in module `tokio::task`
    RUSTFLAGS = "--cfg tokio_unstable";
  };

  # requires a complex setup with podman for the end-to-end tests
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "LibSQL with extended capabilities like HTTP protocol, replication, and more";
    homepage = "https://github.com/tursodatabase/libsql";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "sqld";
  };
})
