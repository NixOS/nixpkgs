{
  lib,
  rustPackages_1_89,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  xz,
  zstd,
}:

# error: rustc 1.86.0 is not supported by the following packages:
#   fs-lock@0.1.11 requires rustc 1.89.0
#   home@0.5.12 requires rustc 1.88
rustPackages_1_89.rustPlatform.buildRustPackage rec {
  pname = "cargo-binstall";
  version = "1.15.9";

  src = fetchFromGitHub {
    owner = "cargo-bins";
    repo = "cargo-binstall";
    tag = "v${version}";
    hash = "sha256-v/tilaoDLZDV0VbMTT/DfqSNO4Ezyu3AWGzMftMubqc=";
  };

  cargoHash = "sha256-itYqZi1tSWVwqGfNFSBh4/+PoLrQZQTnla4lOCjoX8Q=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    xz
    zstd
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "fancy-no-backtrace"
    "git"
    "pkg-config"
    "rustls"
    "trust-dns"
    "zstd-thin"
  ];

  cargoBuildFlags = [
    "-p"
    "cargo-binstall"
  ];
  cargoTestFlags = [
    "-p"
    "cargo-binstall"
  ];

  checkFlags = [
    # requires internet access
    "--skip=download::test::test_and_extract"
    "--skip=gh_api_client::test::test_gh_api_client_cargo_binstall_no_such_release"
    "--skip=gh_api_client::test::test_gh_api_client_cargo_binstall_v0_20_1"
  ];

  meta = with lib; {
    description = "Tool for installing rust binaries as an alternative to building from source";
    mainProgram = "cargo-binstall";
    homepage = "https://github.com/cargo-bins/cargo-binstall";
    changelog = "https://github.com/cargo-bins/cargo-binstall/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
