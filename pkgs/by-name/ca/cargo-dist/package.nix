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

rustPlatform.buildRustPackage rec {
  pname = "cargo-dist";
<<<<<<< HEAD
  version = "0.30.3";
=======
  version = "0.30.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "cargo-dist";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-x59bUgd89XAwuHwGvREDqAS/cI4Ot7HGTONGbTOgzw8=";
  };

  cargoHash = "sha256-OTbUTYxqEzE3hyHq2hCbhigz5xJT2Bjd/pu6EI+0aWA=";
=======
    hash = "sha256-1stUmm7rtNB2z2srOzDvQ9QaGsS0CySBOHt118vmJoM=";
  };

  cargoHash = "sha256-Il5PVJHoNdifqUcXxKR+j+Lgga0kIsl7IJp9oGanZ+c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Tool for building final distributable artifacts and uploading them to an archive";
    mainProgram = "dist";
    homepage = "https://github.com/axodotdev/cargo-dist";
    changelog = "https://github.com/axodotdev/cargo-dist/blob/${src.rev}/CHANGELOG.md";
<<<<<<< HEAD
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
=======
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      matthiasbeyer
      mistydemeo
    ];
  };
}
