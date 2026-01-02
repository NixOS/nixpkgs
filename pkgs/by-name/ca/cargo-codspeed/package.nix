{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-codspeed";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "codspeed-rust";
    rev = "v${version}";
    hash = "sha256-ofVgb+9YUNiCPhRZHY3Fm1nXRZK+9Uq8pc5XAm3P6oU=";
  };

  cargoHash = "sha256-xcLs2Tdi7wp7F5Jwl1QvEC1wQeK7pBjBZKxGVrzqzu0=";

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2
    openssl
    zlib
  ];

  cargoBuildFlags = [ "-p=cargo-codspeed" ];
  cargoTestFlags = cargoBuildFlags;
  checkFlags = [
    # requires an extra dependency, blit
    "--skip=test_package_in_deps_build"

    # requires criteron, which requires additional dependencies
    "--skip=test_cargo_config_rustflags"

    # requires additional dependencies
    "--skip=test_criterion_build_and_run_filtered_by_name"
    "--skip=test_criterion_build_and_run_filtered_by_name_single"
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = {
    description = "Cargo extension to build & run your codspeed benchmarks";
    homepage = "https://github.com/CodSpeedHQ/codspeed-rust";
    changelog = "https://github.com/CodSpeedHQ/codspeed-rust/releases/tag/${src.rev}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ ];
    mainProgram = "cargo-codspeed";
  };
}
