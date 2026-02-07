{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pytest-language-server";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "bellini666";
    repo = "pytest-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-77lgBO7AujADLtkfjYbvPrgAt5s0K71G+rwKbdX9jJw=";
  };

  cargoHash = "sha256-ygOvj12N80No5SFyf26qg12rQVGEuQPBkGc8ahy7X9A=";

  checkFlags = [
    # Depends on being able to create a tmp dir
    "--skip=test_exclude_patterns_glob_matching"
    "--skip=test_exclude_patterns_in_workspace_scan"
    "--skip=test_cli_fixtures_list_full_output"
    "--skip=test_cli_fixtures_list_only_unused"
    "--skip=test_cli_fixtures_list_skip_unused"
    "--skip=test_cli_fixtures_unused_json_output"
    "--skip=test_cli_fixtures_unused_text_output"
    "--skip=test_e2e_cli_class_based_fixtures_shown_as_used"
    "--skip=test_e2e_cli_fixtures_list_with_renamed"
    "--skip=test_e2e_imported_fixtures_cli_shows_them"
    "--skip=test_e2e_mixed_valid_and_invalid_files"
    "--skip=test_scan_skips_git_directory"
    "--skip=test_scan_skips_multiple_directories"
    "--skip=test_scan_skips_nested_node_modules"
    "--skip=test_scan_skips_node_modules"
    "--skip=test_scan_skips_pycache"
    "--skip=test_scan_skips_venv_but_scans_plugins"
    "--skip=test_scan_workspace_with_deeply_nested_structure"
    "--skip=test_scan_workspace_with_mixed_file_types"
    "--skip=test_find_references_uses_reverse_index"
  ];

  doInstallCheck = true;
  nativeInstallInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pytest Language Server";
    homepage = "https://github.com/bellini666/pytest-language-server";
    changelog = "https://github.com/bellini666/pytest-language-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "pytest-language-server";
  };
})
