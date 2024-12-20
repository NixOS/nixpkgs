{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "grcov";
  version = "0.8.19";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "grcov";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-1t+hzB9sSApLScCkjBnLk9i2dsoEwZmWCFukEOvHhZI=";
  };

  cargoPatches = [
    ./0001-update-time-rs.patch
  ];

  cargoHash = "sha256-zbraeXyuXgif46tRFQpEZVZ6bInrgKbrqRArmjFIgU8=";

  # tests do not find grcov path correctly
  checkFlags =
    let
      skipList = [
        "test_coveralls_service_job_id_is_not_sufficient"
        "test_coveralls_service_name_is_not_sufficient"
        "test_coveralls_works_with_just_service_name_and_job_id_args"
        "test_coveralls_works_with_just_token_arg"
        "test_integration"
        "test_integration_guess_single_file"
        "test_integration_zip_dir"
        "test_integration_zip_zip"
      ];
      skipFlag = test: "--skip " + test;
    in
    builtins.concatStringsSep " " (builtins.map skipFlag skipList);

  meta = {
    description = "Rust tool to collect and aggregate code coverage data for multiple source files";
    mainProgram = "grcov";
    homepage = "https://github.com/mozilla/grcov";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ DieracDelta ];
  };
}
