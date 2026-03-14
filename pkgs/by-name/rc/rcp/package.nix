{
  lib,
  pkgsStatic,
  fetchFromGitHub,
}:

pkgsStatic.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rcp";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "rcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ANFzZwklGoTOd+2LFe3WaWSVOUmn1WjwSLaoTJTtXeg=";
  };

  cargoHash = "sha256-SI6L6HtvA6pBvi7xeJThwiueSz/kDlT9zR6pahrIjSM=";

  env.RUSTFLAGS = "--cfg tokio_unstable";

  checkFlags = [
    # these tests set setuid permissions on a test file (3oXXX) which doesn't work in a sandbox
    "--skip=copy::copy_tests::check_default_mode"
    "--skip=test_weird_permissions"
    "--skip=test_edge_case_special_permissions"
    # these tests require network access to determine local IP address
    "--skip=test_remote"
    # these tests expect to find version/git info from Cargo.toml, which isn't available in the sandbox
    "--skip=version::tests::test_current_version"
    "--skip=test_protocol_version_has_git_info"
    "--skip=test_rcpd_protocol_version_has_git_info"
  ];

  meta = {
    changelog = "https://github.com/wykurz/rcp/releases/tag/v${finalAttrs.version}";
    description = "Tools to efficiently copy, remove and link large filesets";
    homepage = "https://github.com/wykurz/rcp";
    license = with lib.licenses; [ mit ];
    mainProgram = "rcp";
    maintainers = with lib.maintainers; [ wykurz ];
    # procfs only supports Linux and Android
    broken = pkgsStatic.stdenv.hostPlatform.isDarwin;
  };
})
