{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dua";
  version = "2.37.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vEc41MspD4Z8E8oFwPw52CiOguqgHQKUZ9Q8GooXPRA=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoHash = "sha256-0ZdQ9ocl62SR74HlVqTYtGxAyf3HGUFCZinPbLBPPbw=";

  checkFlags = [
    # Skip interactive tests
    "--skip=interactive::app::tests::journeys_readonly::quit_instantly_when_nothing_marked"
    "--skip=interactive::app::tests::journeys_readonly::quit_requires_two_presses_when_items_marked"
    "--skip=interactive::app::tests::journeys_readonly::once_allows_replayed_quit_to_exit stdout"
    "--skip=interactive::app::tests::journeys_readonly::simple_user_journey_read_only"
    "--skip=interactive::app::tests::journeys_with_writes::basic_user_journey_with_deletion"
    "--skip=interactive::app::tests::unit::it_can_handle_ending_traversal_reaching_top_but_skipping_levels"
    "--skip=interactive::app::tests::unit::it_can_handle_ending_traversal_without_reaching_the_top"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to conveniently learn about the disk usage of directories";
    homepage = "https://github.com/Byron/dua-cli";
    changelog = "https://github.com/Byron/dua-cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      killercup
      defelo
    ];
    mainProgram = "dua";
  };
})
