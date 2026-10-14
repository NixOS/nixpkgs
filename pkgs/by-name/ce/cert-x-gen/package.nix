{
  lib,
  fetchFromGitHub,
  libgit2,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  zlib,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cert-x-gen";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Bugb-Technologies";
    repo = "cert-x-gen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J3VPPOvBKitgtCi5h8LcXkcfFNciMKX0q8cQ/ytXncg=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-ze5wLwwp2XdWQNEY+n+M6ZTYfw+QQZUR6V9/mgb32RI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
    zstd
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Polyglot execution engine and CLI for vulnerability detection using real code";
    homepage = "https://github.com/Bugb-Technologies/cert-x-gen";
    changelog = "https://github.com/Bugb-Technologies/cert-x-gen/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cxg";
  };
})
