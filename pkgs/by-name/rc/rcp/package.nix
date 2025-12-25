{
  lib,
  pkgsStatic,
  fetchFromGitHub,
}:

pkgsStatic.rustPlatform.buildRustPackage rec {
  pname = "rcp";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "rcp";
    rev = "v${version}";
    hash = "sha256-GdWFS1hKs1POSrnZ5Ilqe+x16DWMaB9rYyxivbV7W88=";
  };

  cargoHash = "sha256-mQd8msIEZdI0lJcvjV1baPkzjJV5wMXV3UrvND2ixp0=";

  RUSTFLAGS = "--cfg tokio_unstable";

  checkFlags = [
    # these tests set setuid permissions on a test file (3oXXX) which doesn't work in a sandbox
    "--skip=copy::copy_tests::check_default_mode"
    "--skip=test_weird_permissions"
    "--skip=test_edge_case_special_permissions"
    # these tests require network access to determine local IP address
    "--skip=test_remote"
    # these tests expect git_describe from build.rs which isn't available in nix build
    "--skip=version::tests::test_current_version"
    "--skip=test_protocol_version_has_git_info"
    "--skip=test_rcpd_protocol_version_has_git_info"
  ];

  meta = {
    changelog = "https://github.com/wykurz/rcp/releases/tag/v${version}";
    description = "Tools to efficiently copy, remove and link large filesets";
    homepage = "https://github.com/wykurz/rcp";
    license = with lib.licenses; [ mit ];
    mainProgram = "rcp";
    maintainers = with lib.maintainers; [ wykurz ];
    # procfs only supports Linux and Android
    broken = pkgsStatic.stdenv.hostPlatform.isDarwin;
  };
}
