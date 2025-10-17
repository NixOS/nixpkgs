{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  xz,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-binstall";
  version = "1.15.6";

  src = fetchFromGitHub {
    owner = "cargo-bins";
    repo = "cargo-binstall";
    rev = "v${version}";
    hash = "sha256-TzO7xz58nvuT6r8SN0cUKdW0x1yR1FlpsnGhU67SNOA=";
  };

  cargoHash = "sha256-cYjsSPHcWYobosSlB2tLda3NSGUTxE5DyA4AxAF8C/8=";

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

  meta = {
    description = "Tool for installing rust binaries as an alternative to building from source";
    mainProgram = "cargo-binstall";
    homepage = "https://github.com/cargo-bins/cargo-binstall";
    changelog = "https://github.com/cargo-bins/cargo-binstall/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
