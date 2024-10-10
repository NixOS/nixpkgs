{
  lib,
  fetchFromGitHub,
  git,
  libiconv,
  ncurses,
  openssl,
  pkg-config,
  rustPlatform,
  sqlite,
  stdenv,
  Security,
  SystemConfiguration,
  fetchpatch2,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-branchless";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${version}";
    hash = "sha256-4RRSffkAe0/8k4SNnlB1iiaW4gWFTuYXplVBj2aRIdU=";
  };

  cargoHash = "sha256-Jg4d7tJXr2O1sEDdB/zk+7TPBZvgHlmW8mNiXozLKV8=";

  patches = [
    (fetchpatch2 {
      name = "1322-fix-for-git-2_45";
      url = "https://patch-diff.githubusercontent.com/raw/arxanas/git-branchless/pull/1322.patch";
      hash = "sha256-3FTuNJ/AKIgQpxJsg7XJA3imvh7m1BkjnaphV7gSRWM=";
    })
    (fetchpatch2 {
      name = "1400-fix-issue-with-system-locale";
      url = "https://patch-diff.githubusercontent.com/raw/arxanas/git-branchless/pull/1400.patch";
      hash = "sha256-S8bSgW0spyZuHGXPdW4A6+BFYhYX8PzIe8+fxZOnvqg=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      ncurses
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
      libiconv
    ];

  postInstall = lib.optionalString (with stdenv; buildPlatform.canExecute hostPlatform) ''
    $out/bin/git-branchless install-man-pages $out/share/man
  '';

  preCheck = ''
    export TEST_GIT=${git}/bin/git
    export TEST_GIT_EXEC_PATH=$(${git}/bin/git --exec-path)
  '';
  checkFlags = [
    # FIXME: these tests deadlock when run in the Nix sandbox
    "--skip=test_switch_pty"
    "--skip=test_next_ambiguous_interactive"
    "--skip=test_switch_auto_switch_interactive"
    # harmless failures, also appear in upstream CI
    # see e.g. https://github.com/user-attachments/files/17016948/git-branchless-job-logs.txt
    "--skip=test_amend_undo" # git-branchless#1345
    # harmless, extra: "branchless: processing 1 update: ref HEAD"
    "--skip=test_symbolic_transaction_ref"
    "--skip=test_move_branch_on_merge_conflict_resolution"
    "--skip=test_move_branches_after_move"
    "--skip=test_move_delete_checked_out_branch"
    "--skip=test_move_no_reapply_squashed_commits"
    "--skip=test_move_orphaned_root"
    "--skip=test_restore_snapshot_basic"
    "--skip=test_restore_snapshot_delete_file_only_in_index"
    "--skip=test_restore_snapshot_deleted_files"
    "--skip=test_sync_basic"
    "--skip=test_sync_no_delete_main_branch"
    # probably harmless, without the extra "Check out from ... to ..." step
    "--skip=test_undo_doesnt_make_working_dir_dirty"
    "--skip=test_undo_move_refs"
    "--skip=test_undo_noninteractive"
    # probably harmless, different EventCursor::event_id
    "--skip=test_undo_hide"
  ];
  cargoTestFlags = [
    "--no-fail-fast" # make post-mortem easier
  ];

  meta = with lib; {
    description = "Suite of tools to help you visualize, navigate, manipulate, and repair your commit history";
    homepage = "https://github.com/arxanas/git-branchless";
    license = licenses.gpl2Only;
    mainProgram = "git-branchless";
    maintainers = with maintainers; [
      nh2
      hmenke
      bryango
    ];
  };
}
