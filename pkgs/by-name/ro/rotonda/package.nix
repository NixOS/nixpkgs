{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  testers,
  rotonda,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rotonda";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "rotonda";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B2sdQr9PctWZBpDuatJkUApW5T98BQa4HiqL8+HHevY=";
  };

  cargoHash = "sha256-XbBlA7QYUtD4uBz4t5ZR70o9bMgVLeSzq6Lexe0jzME=";

  checkFlags =
    lib.optionals
      (stdenv.hostPlatform.system == "aarch64-darwin" || stdenv.hostPlatform.system == "x86_64-darwin")
      [
        # Attempted to create a NULL object.
        "--skip=manager::tests::added_target_should_be_spawned"
        # Lazy instance has previously been poisoned
        "--skip=manager::tests::modified_settings_are_correctly_announced"
        "--skip=manager::tests::removed_target_should_be_terminated"
        "--skip=manager::tests::unused_unit_should_not_be_spawned"
      ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = rotonda;
      command = "rotonda --version";
      # tag/release with this version string, please revert to `inherit (finalAttrs) version;` on next release
      version = "0.4.3-dev";
    };
  };

  meta = {
    description = "Composable, programmable BGP Engine";
    homepage = "https://github.com/NLnetLabs/rotonda";
    changelog = "https://github.com/NLnetLabs/rotonda/blob/refs/tags/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "rotonda";
  };
})
