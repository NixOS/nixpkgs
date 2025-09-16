{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "grcov";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "grcov";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e3RQn6wKvVm40UK8ZlgIi2gRS9eEFBnEXdmXtCgv0Go=";
  };

  cargoHash = "sha256-v4laGVbWmK8WFJXX5ChtViyKyMtmwpehSgNG6F31Mn0=";

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
})
