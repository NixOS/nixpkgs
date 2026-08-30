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
  version = "0.22";

  src = fetchFromGitHub {
    owner = "boa-dev";
    repo = "boa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DwuLNouuFO/hBBlXWx+DgHJ88A08JJm6GnNKhx3enkI=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-EystGcIjJV/XsQgLJqCpY9wEv9XSOru+7+K6r8dzXV8=";

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
