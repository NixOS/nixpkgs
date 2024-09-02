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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${version}";
    hash = "sha256-4RRSffkAe0/8k4SNnlB1iiaW4gWFTuYXplVBj2aRIdU=";
  };

  cargoHash = "sha256-Jg4d7tJXr2O1sEDdB/zk+7TPBZvgHlmW8mNiXozLKV8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      ncurses
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.isDarwin [
      Security
      SystemConfiguration
      libiconv
    ];

  postInstall = ''
    $out/bin/git-branchless install-man-pages $out/share/man
  '';

  preCheck = ''
    export TEST_GIT=${git}/bin/git
    export TEST_GIT_EXEC_PATH=$(${git}/bin/git --exec-path)
  '';
  # FIXME: these tests deadlock when run in the Nix sandbox
  checkFlags = [
    "--skip=test_switch_pty"
    "--skip=test_next_ambiguous_interactive"
    "--skip=test_switch_auto_switch_interactive"
    "--skip=test_amend_undo"
    "--skip=test_switch_pty"
    "--skip=test_next_ambiguous_interactive"
    "--skip=test_switch_auto_switch_interactive"
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
    "--skip=test_undo_doesnt_make_working_dir_dirty"
    "--skip=test_undo_move_refs"
    "--skip=test_undo_noninteractive"
  ];

  meta = with lib; {
    description = "Suite of tools to help you visualize, navigate, manipulate, and repair your commit history";
    homepage = "https://github.com/arxanas/git-branchless";
    license = licenses.gpl2Only;
    mainProgram = "git-branchless";
    maintainers = with maintainers; [
      nh2
      hmenke
    ];
  };
}
