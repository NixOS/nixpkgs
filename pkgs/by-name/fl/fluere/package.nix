{
  lib,
  fetchFromGitHub,
  libgit2,
  libpcap,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  zlib,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluere";
  version = "0.8.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SkuldNorniern";
    repo = "fluere";
    tag = "v${finalAttrs.version}";
    hash = "sha256-311VCO+8xoWblt6zBOLd+7xmmBO7sE0KeUKO1Qwg9SI=";
  };

  cargoHash = "sha256-nMh4hO9kHCpE/+K1DNZT3UYe0iGUU6HRZUg00T6f+CM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    libpcap
    openssl
    zlib
    zstd
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  env = {
    LIBGIT2_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool designed for network monitoring and analysis";
    homepage = "https://github.com/SkuldNorniern/fluere";
    changelog = "https://github.com/SkuldNorniern/fluere/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "fluere";
  };
})
