{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.32.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    tag = "v${version}";
    hash = "sha256-u8g7X/70ZsZF6vUiVnisItwSMiNXgiAdOXqGUT34EaY=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/fixtures
    '';
  };

  cargoHash = "sha256-6WjaKGCnEoHCIDqMHtp/dpdHbrUe2XOxCtstQCuXPyc=";

  checkFlags = [
    # Skip interactive tests
    "--skip=interactive::app::tests::journeys_readonly::simple_user_journey_read_only"
    "--skip=interactive::app::tests::journeys_with_writes::basic_user_journey_with_deletion"
    "--skip=interactive::app::tests::unit::it_can_handle_ending_traversal_reaching_top_but_skipping_levels"
    "--skip=interactive::app::tests::unit::it_can_handle_ending_traversal_without_reaching_the_top"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to conveniently learn about the disk usage of directories";
    homepage = "https://github.com/Byron/dua-cli";
    changelog = "https://github.com/Byron/dua-cli/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      figsoda
      killercup
    ];
    mainProgram = "dua";
  };
}
