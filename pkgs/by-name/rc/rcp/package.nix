{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rcp";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "rcp";
    rev = "v${version}";
    hash = "sha256-mFFMxGu/r8xtfMkpDW2Rk/oTWQcS9oK6ngoRKCc+STo=";
  };

  cargoHash = "sha256-2S3bygSu9ouT/RYCmafFGvFHHFJXVryb5E3PMmcZs0U=";

  RUSTFLAGS = "--cfg tokio_unstable";

  checkFlags = [
    # this test also sets setuid permissions on a test file (3oXXX) which doesn't work in a sandbox
    "--skip=copy::copy_tests::check_default_mode"
  ];

  meta = {
    changelog = "https://github.com/wykurz/rcp/releases/tag/v${version}";
    description = "Tools to efficiently copy, remove and link large filesets";
    homepage = "https://github.com/wykurz/rcp";
    license = with lib.licenses; [ mit ];
    mainProgram = "rcp";
    maintainers = with lib.maintainers; [ wykurz ];
    # Building procfs on an for a unsupported platform. Currently only linux and android are supported
    # (Your current target_os is macos)
    broken = stdenv.hostPlatform.isDarwin;
  };
}
