{
  lib,
  boost,
  cacert,
  cmake,
  fetchFromGitHub,
  libgit2,
  nix-update-script,
  openssl,
  pkg-config,
  rust-jemalloc-sys,
  rustPlatform,
  sqlite,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kingfisher";
  version = "2.14.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "kingfisher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IE1ok5FKCP91MG+/unI/muJkOctBS/VlldwgtbXtV0c=";
  };

  cargoHash = "sha256-nP7siKy0x0vPyEnlXt4f7c2Y1PTrvd9Z+qmPyfKetng=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    libgit2
    openssl
    rust-jemalloc-sys
    sqlite
    zlib
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    VECTORSCAN_BUILD_FROM_SOURCE = "1";
  };

  # Integration tests exceed memory limits and can crash
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to detect leaked secrets and perform live validation";
    homepage = "https://github.com/mongodb/kingfisher";
    changelog = "https://github.com/mongodb/kingfisher/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "kingfisher";
  };
})
