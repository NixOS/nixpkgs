{
  lib,
  aws-lc,
  bash,
  cacert,
  fetchFromGitHub,
  libgit2,
  nodejs,
  openssl,
  pkg-config,
  procps,
  python3,
  rustPlatform,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  zlib,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cert-x-gen";
  version = "1.9.2";

  __darwinAllowLocalNetworking = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Bugb-Technologies";
    repo = "cert-x-gen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a08Im1jCtFExi0MsiwKmQhi4LolWFMx5hAqpG3kMaHI=";
  };

  postPatch = ''
    substituteInPlace src/engine/shell/mod.rs \
      --replace-fail /bin/bash ${lib.getExe bash}
    patchShebangs tests/fixtures
  '';

  cargoHash = "sha256-TEDyiRwkoIt3reMfN6ZZE8/+KT0/Z4aRtGPjdPisDos=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    aws-lc
    libgit2
    openssl
    zlib
    zstd
  ];

  nativeCheckInputs = [
    cacert
    nodejs
    procps
    python3
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    # an empty RUST_LOG from the build hooks disables the verbosity flags
    unset RUST_LOG
  '';

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
