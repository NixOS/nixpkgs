{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rcp";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "rcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ayT8lp8XqkvtUaff2Iy+5IVyJ/ukKl0qruEWjBlgAvo=";
  };

  cargoHash = "sha256-AcH5V5hapVQgGrwWAEN6Xpj00RRNqZiCSn+/onpmd50=";

  env.RUSTFLAGS = "--cfg tokio_unstable";

  checkFlags = [
    # these tests set setuid permissions on a test file (3oXXX) which doesn't work in a sandbox
    "--skip=copy::copy_tests::check_default_mode"
    "--skip=test_weird_permissions"
    "--skip=test_edge_case_special_permissions"
    # these tests require network access to determine local IP address
    "--skip=test_remote"
  ];

  meta = {
    changelog = "https://github.com/wykurz/rcp/releases/tag/v${finalAttrs.version}";
    description = "Tools to efficiently copy, remove and link large filesets";
    homepage = "https://github.com/wykurz/rcp";
    license = with lib.licenses; [ mit ];
    mainProgram = "rcp";
    maintainers = with lib.maintainers; [ wykurz ];
    # Building procfs on an for a unsupported platform. Currently only linux and android are supported
    # (Your current target_os is macos)
    broken = stdenv.hostPlatform.isDarwin;
  };
})
