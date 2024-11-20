{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.41.1";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = version;
    hash = "sha256-4u/BXHKkp7vlXFFlbZg+jon37jszPCtg7P00SfTkBIQ=";
  };

  cargoHash = "sha256-Nr+7XmqWt3qAhb8HxKg8qGlS5ZX3uR5FEr/pf7qNiBY=";

  checkFlags = [
  # Depends on `rustfmt` and does not matter for packaging.
  "--skip=utils::test_format_rust_expression"
  # Requires networking
  "--skip=test_force_update_snapshots"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Cargo subcommand for snapshot testing";
    mainProgram = "cargo-insta";
    homepage = "https://github.com/mitsuhiko/insta";
    changelog = "https://github.com/mitsuhiko/insta/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda oxalica matthiasbeyer ];
  };
}
