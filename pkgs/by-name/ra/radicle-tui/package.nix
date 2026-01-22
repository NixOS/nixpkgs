{
  lib,
  rustPlatform,
  fetchFromRadicle,
  stdenv,
  libiconv,
  zlib,
  radicle-node,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-tui";
  version = "0.6.0";

  src = fetchFromRadicle {
    seed = "seed.radicle.xyz";
    repo = "z39mP9rQAaGmERfUMPULfPUi473tY";
    node = "z6MkswQE8gwZw924amKatxnNCXA55BMupMmRg7LvJuim2C1V";
    tag = finalAttrs.version;
    hash = "sha256-rz9l9GtycqZoROUI6Hn0Fv5Br0YCIrcHlEWLMP4hasQ=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/.git_head
      git -C $out log -1 --pretty=%ct HEAD > $out/.git_time
      rm -rf $out/.git
    '';
  };

  cargoHash = "sha256-f9D4RKWw7y6z9rERuF7F6soyNITvKa6QVt34biZZ5JY=";

  postPatch = ''
    substituteInPlace build.rs \
      --replace-fail "GIT_HEAD={hash}" "GIT_HEAD=$(<.git_head)" \
      --replace-fail "GIT_COMMIT_TIME={commit_time}" "GIT_COMMIT_TIME=$(<.git_time)"
  '';

  nativeCheckInputs = [ radicle-node ];

  checkFlags = [
    "--skip=cli::can_be_executed"
    "--skip=cli::empty_command_is_forwarded"
    "--skip=cli::help_command_is_forwarded"
    "--skip=cli::version_command_is_forwarded"
    "--skip=commands::tui_inbox::cli::empty_operation"
    "--skip=commands::tui_inbox::cli::empty_operation_is_not_forwarded"
    "--skip=commands::tui_inbox::cli::empty_operation_is_not_forwarded_explicitly"
    "--skip=commands::tui_inbox::cli::empty_operation_with_help_is_forwarded"
    "--skip=commands::tui_inbox::cli::list_operation_is_not_forwarded"
    "--skip=commands::tui_inbox::cli::list_operation_is_not_forwarded_explicitly"
    "--skip=commands::tui_inbox::cli::list_operation_with_help_is_forwarded"
    "--skip=commands::tui_inbox::cli::unknown_operation_show_is_forwarded"
    "--skip=commands::tui_patch::cli::empty_operation"
    "--skip=commands::tui_patch::cli::empty_operation_is_not_forwarded"
    "--skip=commands::tui_patch::cli::empty_operation_is_not_forwarded_explicitly"
    "--skip=commands::tui_patch::cli::empty_operation_with_help_is_forwarded"
    "--skip=commands::tui_patch::cli::list_operation_is_not_forwarded"
    "--skip=commands::tui_patch::cli::list_operation_is_not_forwarded_explicitly"
    "--skip=commands::tui_patch::cli::list_operation_with_help_is_forwarded"
    "--skip=commands::tui_patch::cli::unknown_operation_edit_is_forwarded"
    "--skip=commands::tui_patch::cli::unknown_operation_is_not_forwarded"
    "--skip=commands::tui_patch::cli::unknown_operation_show_is_forwarded"
    "--skip=commands::tui_patch::review::test::app_with_single_file_multiple_hunks_can_be_constructed"
    "--skip=commands::tui_patch::review::test::app_with_single_hunk_can_be_constructed"
    "--skip=commands::tui_patch::review::test::first_hunk_is_selected_by_default"
    "--skip=commands::tui_patch::review::test::hunk_can_be_selected"
    "--skip=commands::tui_patch::review::test::hunks_are_rejected_by_default"
    "--skip=commands::tui_patch::review::test::multiple_files_single_hunk_can_be_accepted"
    "--skip=commands::tui_patch::review::test::single_file_multiple_hunks_only_last_can_be_accepted"
    "--skip=commands::tui_patch::review::test::single_file_single_hunk_can_be_accepted"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    zlib
  ];

  propagatedUserEnvPkgs = [ radicle-node ];

  postInstall = ''
    wrapProgram $out/bin/rad-tui \
      --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs}
  '';

  # versionCheckHook doesn't support multiple arguments yet
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/rad-tui --version --no-forward | grep -F 'rad-tui ${finalAttrs.version}'
    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Radicle terminal user interface";
    homepage = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z39mP9rQAaGmERfUMPULfPUi473tY";
    changelog = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z39mP9rQAaGmERfUMPULfPUi473tY/tree/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
      defelo
    ];
    mainProgram = "rad-tui";
  };
})
