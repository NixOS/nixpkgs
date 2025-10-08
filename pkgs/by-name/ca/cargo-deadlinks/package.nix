{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deadlinks";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "deadlinks";
    repo = "cargo-deadlinks";
    tag = version;
    sha256 = "0s5q9aghncsk9834azn5cgnn5ms3zzyjan2rq06kaqcgzhld4cjh";
  };

  cargoHash = "sha256-d5e5CpO/c6KrIQE8dJqXT19Qe0CRbIqgCDHNWz4TK8Q=";

  checkFlags = [
    # uses internet
    "--skip non_existent_http_link --skip working_http_check"
    # makes assumption about HTML paths that changed in rust 1.82.0
    "--skip simple_project::it_checks_okay_project_correctly"
    "--skip cli_args::it_passes_arguments_through_to_cargo"
  ]
  ++
    lib.optional (stdenv.hostPlatform.system != "x86_64-linux")
      # assumes the target is x86_64-unknown-linux-gnu
      "--skip simple_project::it_checks_okay_project_correctly";

  meta = {
    description = "Cargo subcommand to check rust documentation for broken links";
    homepage = "https://github.com/deadlinks/cargo-deadlinks";
    changelog = "https://github.com/deadlinks/cargo-deadlinks/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      newam
      matthiasbeyer
    ];
  };
}
