{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  runtimeShell,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-insta";
  version = "1.48.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    tag = finalAttrs.version;
    hash = "sha256-xIveukm1BsvY6z6bCsV4L9RZGIalspFEYFthE4hCaH8=";
  };

  cargoHash = "sha256-OlCNm4N+cLreN7iR25cD06vsGnE+IWo5T15h3I6tCa8=";

  nativeCheckInputs = [
    # used by test_binary_accept_missing_old_binary
    git
  ];

  postPatch = ''
    substituteInPlace cargo-insta/tests/functional/test_runner_fallback.rs \
      --replace-fail '#!/bin/bash' '#!${runtimeShell}'
  '';

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
    changelog = "https://github.com/mitsuhiko/insta/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      oxalica
      matthiasbeyer
      figsoda
    ];
  };
})
