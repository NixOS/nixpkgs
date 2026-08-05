{
  lib,
  pkgsStatic,
  fetchFromGitHub,
}:

pkgsStatic.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rcp";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "rcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-svJA9QyqwpY1xzOQ09qFlZwrGp3HZXW9T2AICVJfqOs=";
  };

  cargoHash = "sha256-QJr6kM520OWxje7Q5FZWgJH1IS8j+Jv1vNf7VyCINNA=";

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
    "--skip=no_setid_clears_bits_for_unchanged_owner_rule"
    "--skip=no_setid_clears_existing_bits_for_unrelated_mode"
    "--skip=no_setid_dry_run_reports_but_does_not_clear_bits"
    "--skip=no_setid_respects_filter_and_per_type_scope"
    "--skip=no_setid_retains_sticky_and_clears_setgid_on_directory"
    # this test expects overwrite behavior that doesn't work in a sandbox
    "--skip=test_overwrite_behavior"
    # these tests require network access to determine local IP address
    "--skip=test_remote"
    # these tests expect to find version/git info from Cargo.toml, which isn't available in the sandbox
    "--skip=version::tests::test_current_version"
    "--skip=test_protocol_version_has_git_info"
    "--skip=test_rcpd_protocol_version_has_git_info"
    # these tests shell out to `getent` to resolve real user/group names, which isn't available in the sandbox
    "--skip=chmod::tests::getent_real_resolves_root"
    "--skip=chmod::tests::getent_real_option_like_name_fails_closed_no_injection"
    "--skip=rejects_unknown_group"
    # these tests change ownership and set setuid/setgid bits (fchown / chmod / chgrp),
    # which the unprivileged sandbox build user isn't permitted to do (EPERM)
    "--skip=safedir::tests::set_dir_metadata_fd_applies"
    "--skip=safedir::tests::set_file_metadata_fd_ordering_preserves_setuid"
    "--skip=applies_per_type_modes_recursively"
    "--skip=group_change_preserves_setgid_across_chgrp"
    "--skip=preserves_setgid_through_mode_change"
  ];

  meta = {
    changelog = "https://github.com/wykurz/rcp/releases/tag/v${finalAttrs.version}";
    description = "Tools to efficiently copy, remove and link large filesets";
    homepage = "https://github.com/wykurz/rcp";
    license = lib.licenses.mit;
    mainProgram = "rcp";
    maintainers = with lib.maintainers; [ wykurz ];
    # procfs only supports Linux and Android
    broken = pkgsStatic.stdenv.hostPlatform.isDarwin;
  };
})
