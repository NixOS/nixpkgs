{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  openssl,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "boa";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "boa-dev";
    repo = "boa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-APzbYaQ9DF7jpr7tRvF/RWpD3TTm/4pApFf4WNcQ9XU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-DcSTYNpoLWIy35dHUc52ASpmkzdCwDmDlY9fFKOfJpw=";

  # cargo-auditable fails on `dep:either`.
  auditable = false;

  cargoBuildFlags = [
    "--package"
    "boa_cli"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    openssl
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Embeddable and experimental Javascript engine written in Rust";
    homepage = "https://github.com/boa-dev/boa";
    changelog = "https://github.com/boa-dev/boa/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit # or
      unlicense
    ];
    mainProgram = "boa";
    maintainers = with lib.maintainers; [ iamanaws ];
  };
})
