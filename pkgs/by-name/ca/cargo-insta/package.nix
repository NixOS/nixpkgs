{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
<<<<<<< HEAD
  version = "1.45.1";
=======
  version = "1.44.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-uNf2KkwgRCBCVFDN5ql8MisfAoU4+z7XLWogyx8sgKw=";
  };

  cargoHash = "sha256-U9rtovpekFiSv+RhPwgTiUVjAPPDzis1O0RrIOKWcQc=";
=======
    hash = "sha256-Wi68dVKPsCCzt726N21pga73hW1WDDUtSv+o/sJMWpk=";
  };

  cargoHash = "sha256-ks/icINVa7oVfK5yO8H0sUCRFWWzTwURHVALUVZ8uw0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
