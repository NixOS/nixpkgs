{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.42.2";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = "e81bae9b7b7f536bd9057158fe5a219facced116";
    hash = "sha256-5IGp4WuC34wRB7xSiDWzScLvV26yjsdw/LT/7CN9hWc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Vx26ArAcsW0NNVNZa4M5hqz/sm1gecrun/bbRWMu07Q=";

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
      figsoda
      oxalica
      matthiasbeyer
    ];
  };
}
