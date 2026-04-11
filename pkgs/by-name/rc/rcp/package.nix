{
  lib,
  pkgsStatic,
  fetchFromGitHub,
}:

pkgsStatic.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rcp";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "rcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ghFVGbud3aKJPvjNchsgPUSioNAxg4TJlUIYMp9+cJo=";
  };

  cargoHash = "sha256-eyIO8lxmGdZKEDW+GSVARm5u3X0vx1RJLG8Ljbk0Zb8=";

  env.RUSTFLAGS = "--cfg tokio_unstable";

  checkFlags = [
    # these tests set setuid permissions on a test file (3oXXX) which doesn't work in a sandbox
    "--skip=copy::copy_tests::check_default_mode"
    "--skip=test_weird_permissions"
    "--skip=test_edge_case_special_permissions"
    "--skip=test_default_strips_special_bits_on_directories"
    "--skip=test_default_strips_special_bits_on_files"
    "--skip=test_default_preserves_special_bits_on_directories"
    "--skip=test_preserve_all_preserves_special_bits_on_directories"
    "--skip=test_preserve_all_preserves_special_bits_on_files"
    "--skip=test_preserve_settings_dir_gid_time_7777"
    "--skip=test_preserve_settings_dir_7777_preserves_special_bits"
    "--skip=test_preserve_settings_file_7777_preserves_special_bits"
    "--skip=test_preserve_settings_none_strips_special_bits_on_directories"
    # this test expects overwrite behavior that doesn't work in a sandbox
    "--skip=test_overwrite_behavior"
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
