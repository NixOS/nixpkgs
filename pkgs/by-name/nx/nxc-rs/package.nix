{
  lib,
  fetchFromGitHub,
  krb5,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  sqlite,
  versionCheckHook,
  zlib,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nxc-rs";
  version = "0.4.8";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "thrive-spectrexq";
    repo = "nxc-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h0OUv5CrGomXv9Yf4MkSFCOOl4YZ0Yy62mTkrqNUa8c=";
  };

  cargoHash = "sha256-HKQCs1feFE1stHf3fiNAu8eZLd1WcWw6GnnbrDv+al4=";

  nativeBuildInputs = [
    krb5
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    krb5
    openssl
    sqlite
    zlib
    zstd
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  checkFlagsArray = [
    # Test requires raw socket/packet capture
    "--skip=providers::tests::test_provider_debug_redacts_keys"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Network Execution Toolkit";
    homepage = "https://github.com/thrive-spectrexq/nxc-rs";
    changelog = "https://github.com/thrive-spectrexq/nxc-rs/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nxc";
  };
})
