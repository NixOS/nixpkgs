{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  curl,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rail";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-L8yh47lYvXVGOr8jDZ4Gk2rIfUnr88q9OR5/iDrJua0=";
  };

  cargoHash = "sha256-XvXyG3N0cuqqm0LSe7MFj6oDlCQC3tFGa7rxyQIfa8o=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    openssl
  ];

  # These fail because they need a git repository
  checkFlags = [
    "--skip=git::defaults::tests::test_detect_default_base_ref"
    "--skip=git::ops::tests::test_collect_tree_files_nonexistent"
    "--skip=git::defaults::tests::test_detect_returns_usable_ref"
    "--skip=git::mappings::tests::test_reverse_mapping_persistence"
    "--skip=git::mappings::tests::test_save_and_load"
    "--skip=git::ops::tests::test_collect_tree_files_with_bulk"
    "--skip=git::ops::tests::test_get_commits_bulk"
    "--skip=git::ops::tests::test_get_commits_touching_path"
    "--skip=git::ops::tests::test_read_files_bulk"
    "--skip=git::ops::tests::test_get_changed_files"
    "--skip=git::ops::tests::test_commit_history"
    "--skip=git::ops::tests::test_read_files_bulk_empty"
    "--skip=sync::conflict::tests::test_clean_merge"
    "--skip=sync::conflict::tests::test_ours_strategy"
    "--skip=sync::conflict::tests::test_conflict_detection"
    "--skip=sync::conflict::tests::test_union_strategy"
    "--skip=split::engine::tests::test_copy_directory_recursive"
    "--skip=sync::conflict::tests::test_theirs_strategy"
    "--skip=workspace::change_analyzer::tests::test_categorize_comprehensive"
    "--skip=workspace::change_analyzer::tests::test_proc_macro_detection"
    "--skip=workspace::context::tests::test_cargo_state_wrapper"
    "--skip=workspace::context::tests::test_git_state_wrapper"
    "--skip=workspace::context::tests::test_workspace_context_build"
    "--skip=workspace::view::tests::test_workspace_view_all_crates"
    "--skip=workspace::view::tests::test_workspace_view_crate_info"
    "--skip=workspace::view::tests::test_workspace_view_proc_macro"
    "--skip=workspace::context::tests::test_graph_integration"
  ];

  meta = {
    description = "Graph-aware monorepo orchestration for Rust workspaces";
    mainProgram = "cargo-rail";
    homepage = "https://github.com/loadingalias/cargo-rail";
    changelog = "https://github.com/loadingalias/cargo-rail/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
