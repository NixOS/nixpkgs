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
}:

rustPlatform.buildRustPackage rec {
  pname = "git-branchless";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${version}";
    hash = "sha256-8uv+sZRr06K42hmxgjrKk6FDEngUhN/9epixRYKwE3U=";
  };

  cargoHash = "sha256-AEEAHMKGVYcijA+Oget+maDZwsk/RGPhHQfiv+AT4v8=";

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

  # Note that upstream has disabled CI tests for git>=2.46
  # See: https://github.com/arxanas/git-branchless/issues/1416
  #      https://github.com/arxanas/git-branchless/pull/1417
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
