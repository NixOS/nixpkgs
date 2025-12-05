{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.44.3";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    tag = version;
    hash = "sha256-xXp5XqE6teDK519IKM1FAZAAXcQHXlQF2kdRIhS7mYA=";
  };

  cargoHash = "sha256-XdeQ4BQb0/X3R4ST3ZrOo/XvSCzhRR1eqcp3uRWgX9g=";

  checkFlags = [
    # Depends on `rustfmt` and does not matter for packaging.
    "--skip=utils::test_format_rust_expression"
    # Requires networking
    "--skip=test_force_update_snapshots"

    "--skip=test_ignored_snapshots"
    "--skip=workspace::test_insta_workspace_root"
    "--skip=env::test_get_cargo_workspace_manifest_dir"
  ];

  meta = {
    description = "Cargo subcommand for snapshot testing";
    mainProgram = "cargo-insta";
    homepage = "https://github.com/mitsuhiko/insta";
    changelog = "https://github.com/mitsuhiko/insta/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      oxalica
      matthiasbeyer
    ];
  };
}
