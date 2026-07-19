{
  lib,
  boost,
  cmake,
  fetchFromGitHub,
  libgit2,
  nix-update-script,
  openssl,
  pkg-config,
  rust-jemalloc-sys,
  rustPlatform,
  sqlite,
  versionCheckHook,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kingfisher";
  version = "1.107.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "kingfisher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PhrniOr2YRaWbCbI35bhdYzztgegnKVTw/rWX/BMwGQ=";
  };

  cargoHash = "sha256-bEPg0exoNFxk/CZgThn6SXXx6ELJcKvmXBqDVeZlKv4=";

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

  nativeInstallCheckInputs = [ versionCheckHook ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
  };

  doInstallCheck = true;

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
