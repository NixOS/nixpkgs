{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ov-cli";
  version = "0.5.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "volcengine";
    repo = "OpenViking";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kj/dvrgXpvkYeRWubibs3eLYxk20SjOXxeB9tawFMSI=";
  };

  cargoHash = "sha256-Fbh/mz3OdZt/7Lix6EEX5uCnasPUmUnj9FYO86fme60=";

  # Upstream's README documents `cargo install --path crates/ov_cli`; here we
  # build from the workspace root since `cargo build` has no --path flag, and
  # restrict it to the ov_cli member to avoid building the ragfs crates.
  cargoBuildFlags = [
    "--package"
    "ov_cli"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  checkFlags = map (t: "--skip=${t}") [
    # Depend on the terminal size, which is narrow in the build sandbox
    "commands::filesystem::tests::ls_table_output_renders_compact_entry_list"
    "commands::filesystem::tests::ls_table_output_renders_compact_raw_modtime_in_local_timezone"
    "commands::filesystem::tests::ls_table_output_renders_original_iso_modtime_in_local_timezone"
    "commands::filesystem::tests::tree_table_output_renders_indented_tree"
    "commands::search::tests::grep_table_output_renders_match_cards"
    "commands::search::tests::search_output_preserves_content_profile_and_retrieval_failures"
    "commands::search::tests::search_result_cards_render_categorized_find_response"
    "commands::search::tests::search_result_cards_render_ranked_scannable_rows"
    "config_wizard::wizard::tests::live_region_keeps_largest_input_rows_until_clear"
  ];

  env.OPENVIKING_VERSION = finalAttrs.version;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line client for the OpenViking context database";
    homepage = "https://github.com/volcengine/OpenViking";
    changelog = "https://github.com/volcengine/OpenViking/releases/tag/v${finalAttrs.version}";
    # The repository root is AGPLv3, but this sub-project is Apache-2.0,
    # declared in its own Cargo.toml and crates/LICENSE:
    # https://github.com/volcengine/OpenViking/blob/v0.5.5/crates/ov_cli/Cargo.toml#L8
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
    mainProgram = "ov";
  };
})
