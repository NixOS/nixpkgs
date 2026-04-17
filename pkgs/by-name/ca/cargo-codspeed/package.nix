{
  curl,
  fetchFromGitHub,
  lib,
  libgit2,
  openssl,
  pkg-config,
  rustPlatform,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-codspeed";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "codspeed-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2xKTn+fiRyXyH6womZPJoSpBC7nMH9+rBuoZrWL2kQU=";
  };

  cargoHash = "sha256-jN70cNOYLPtIPEji2JF8r/6zphvekRc9y0UNR3xNAUo=";

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
  cargoTestFlags = finalAttrs.cargoBuildFlags;
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
    changelog = "https://github.com/CodSpeedHQ/codspeed-rust/releases/tag/v${finalAttrs.version}";
    description = "Cargo extension to build & run your codspeed benchmarks";
    homepage = "https://github.com/CodSpeedHQ/codspeed-rust";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "cargo-codspeed";
    maintainers = with lib.maintainers; [ hythera ];
  };
})
