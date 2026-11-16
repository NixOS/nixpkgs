{
  lib,
  aws-lc,
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
  version = "2.18.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "kingfisher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZsQre0RvUVnD1PX4KQw0Wb35Z1KqG1O+1nOSryA4dPg=";
  };

  cargoHash = "sha256-F/R6/aFYfBKe85Xb31cyRIdLaf8zsGCoUxvG+NG1FJk=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    aws-lc
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
