{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rcp";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "rcp";
    rev = "v${version}";
    hash = "sha256-mMSO5twpuxiA6pMG/bNMn3WJjs3ZwuoOk62M0WIrRBk=";
  };

  cargoHash = "sha256-uVBWPxGxNgiahywA78QjN8msNx3gZ6vOyX7AkOdK2EM=";

  RUSTFLAGS = "--cfg tokio_unstable";

  checkFlags = [
    # this test also sets setuid permissions on a test file (3oXXX) which doesn't work in a sandbox
    "--skip=copy::copy_tests::check_default_mode"
  ];

  meta = with lib; {
    changelog = "https://github.com/wykurz/rcp/releases/tag/v${version}";
    description = "Tools to efficiently copy, remove and link large filesets";
    homepage = "https://github.com/wykurz/rcp";
    license = with licenses; [ mit ];
    mainProgram = "rcp";
    maintainers = with maintainers; [ wykurz ];
    # Building procfs on an for a unsupported platform. Currently only linux and android are supported
    # (Your current target_os is macos)
    broken = stdenv.hostPlatform.isDarwin;
  };
}
