{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  libssh2,
  openssl,
  zlib,
  xz,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neve";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "MCB-SMART-BOY";
    repo = "Neve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EeN5KrJkrHcdBf/qBPhySDGpYqB6CWEgjuYSbYwuU+E=";
  };

  cargoHash = "sha256-U7mUFiAG2JIO47Ym9sICLWXVhY/EF5PoeHugHMcZswg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    libssh2
    openssl
    zlib
    xz
  ];

  cargoBuildFlags = [
    "-p"
    "neve"
  ];

  doCheck = false;

  env = {
    LIBGIT2_NO_VENDOR = true;
    LIBSSH2_SYS_USE_PKG_CONFIG = true;
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Standalone language for system configuration, builds, and shell automation";
    homepage = "https://github.com/MCB-SMART-BOY/Neve";
    changelog = "https://github.com/MCB-SMART-BOY/Neve/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    mainProgram = "neve";
    platforms = lib.platforms.unix;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
