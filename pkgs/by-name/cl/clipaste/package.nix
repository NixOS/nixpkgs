{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clipaste";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "hqhq1025";
    repo = "clipaste";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tLdtz/zDC3ooh1+8CpVCRc0NqIde08GNf3EMmQFUfCM=";
  };

  cargoHash = "sha256-N2QYxyJApXAeBnG1m3kNwm4d8ZOmjjhmOFF+x6E7as4=";

  strictDeps = true;
  __structuredAttrs = true;

  checkFlags = [
    # Runs the generated bash script in a simulated remote environment
    # (PATH=/usr/bin:/bin:...).  In the Nix sandbox standard tools like `grep`
    # are not available at those paths — syntax check and content assertions
    # already cover correctness.
    "--skip"
    "ssh_setup::tests::remote_script_run_installs_into_empty_home"

    # Need the real NSPasteboard, which is unreachable in the sandbox.
    # The pure-logic tests in the same module still run.
    "--skip"
    "macos::tests::browser_image_with_many_representations_is_normalized"
    "--skip"
    "macos::tests::concurrent_copy_remains_pending_for_the_next_poll"
    "--skip"
    "macos::tests::declared_image_without_data_remains_pending"
    "--skip"
    "macos::tests::image_written_after_an_empty_poll_is_not_lost"
    "--skip"
    "macos::tests::missing_optional_format_does_not_block_valid_image"
    "--skip"
    "macos::tests::normalization_does_not_overwrite_a_newer_copy_during_save"
    "--skip"
    "macos::tests::normalization_links_original_copy_and_preserves_representations"
    "--skip"
    "macos::tests::private_images_and_multiple_items_are_not_normalized"
    "--skip"
    "macos::tests::rapid_distinct_copies_are_processed_and_text_clears_remote_image"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Screenshot clipboard paste fix for AI agents";
    homepage = "https://github.com/hqhq1025/clipaste";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "clipaste";
  };
})
