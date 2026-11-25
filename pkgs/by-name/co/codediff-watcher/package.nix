{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  git,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codediff-watcher";
  version = "0.37.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "esmuellert";
    repo = "codediff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DDHcy9Qe6cl0sFNpvincrecWE/l7gsyHzkIDzizNWxA=";
  };

  cargoHash = "sha256-DTm0O28+qxQvEIa3MMyo+ieFwotV/A2GoJGemFlXYuw=";

  buildAndTestSubdir = "crates/watcher";

  nativeCheckInputs = [ git ];

  # FSEvents cannot start a stream inside the Darwin build sandbox
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # tests/binary
    "--skip=protocol::git_state_changes_cross_the_process_boundary"
    "--skip=protocol::idle_repository_emits_only_ready"
    "--skip=protocol::ready_precedes_refresh_and_both_are_complete_json_lines"
    "--skip=protocol::refresh_write_to_closed_stdout_stops_process"
    "--skip=protocol::repository_path_with_spaces_is_accepted"
    "--skip=workload::mixed_repository_workload_stays_responsive"
    # tests/event_delivery.rs
    "--skip=continuous_edits_emit_without_waiting_for_quiet"
    "--skip=same_size_overwrite_is_seen"
    "--skip=two_thousand_overwrites_remain_worktree_only"
    # tests/live.rs
    "--skip=build_in_ignored_dir_triggers_nothing"
    "--skip=create_directory_with_file"
    "--skip=create_new_file"
    "--skip=delete_tracked_file"
    "--skip=edit_tracked_file"
    "--skip=edit_untracked_file"
    "--skip=git_add_triggers_index"
    "--skip=git_branch_create_triggers_refs"
    "--skip=git_checkout_branch_triggers_head"
    "--skip=git_commit_all_triggers_index_and_refs"
    "--skip=git_commit_triggers_refs"
    "--skip=git_hooks_is_silent"
    "--skip=git_objects_is_silent"
    "--skip=git_reset_triggers_index"
    "--skip=git_switch_branch_triggers_head"
    "--skip=git_tag_triggers_refs"
    "--skip=gitignore_change_triggers_worktree"
    "--skip=lock_file_is_silent"
    "--skip=reading_files_triggers_nothing"
    "--skip=refresh_does_not_feed_itself"
    "--skip=rename_tracked_file"
    "--skip=write_to_gitignored_file"
    "--skip=write_to_nested_ignored_dir"
    # tests/watch_lifecycle.rs
    "--skip=one_hundred_start_stop_cycles_leave_a_usable_watcher"
    # tests/watch_scope.rs
    "--skip=gitignore_changes_take_effect_without_restarting_the_watcher"
    "--skip=info_exclude_changes_take_effect_without_restarting"
    "--skip=nested_gitignore_changes_take_effect_without_restarting"
    "--skip=removing_an_ignore_rule_starts_watching_that_directory"
    # tests/worktree.rs
    "--skip=worktree_add_triggers_index"
    "--skip=worktree_branch_create_triggers_refs"
    "--skip=worktree_commit_triggers_refs"
    "--skip=worktree_edit_triggers_worktree"
    "--skip=worktree_switch_triggers_head"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native repository watcher for codediff.nvim";
    homepage = "https://github.com/esmuellert/codediff";
    license = lib.licenses.mit;
    mainProgram = "codediff-watcher";
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
