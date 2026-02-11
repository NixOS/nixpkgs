{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  bzip2,
  xz,
  zstd,
  git,
  rustup,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-dist";
  version = "0.30.3";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "cargo-dist";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x59bUgd89XAwuHwGvREDqAS/cI4Ot7HGTONGbTOgzw8=";
  };

  cargoHash = "sha256-OTbUTYxqEzE3hyHq2hCbhigz5xJT2Bjd/pu6EI+0aWA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    xz
    zstd
  ];

  nativeCheckInputs = [
    git
    rustup
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # remove tests that require internet access
  postPatch = ''
    rm cargo-dist/tests/cli-tests.rs cargo-dist/tests/integration-tests.rs
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for building final distributable artifacts and uploading them to an archive";
    mainProgram = "dist";
    homepage = "https://github.com/axodotdev/cargo-dist";
    changelog = "https://github.com/axodotdev/cargo-dist/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
      mistydemeo
    ];
  };
})
