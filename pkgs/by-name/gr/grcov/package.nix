{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "grcov";
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "grcov";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P9JOd2Dw3MDQ6Kr9m85JiqQScYdJzEVPtIfTOAc21rs=";
  };

  cargoHash = "sha256-HZXH4sirjaZmHUiVr9A3ZnyqPoMaDTJnMD54/iUYQtg=";

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
        "test_llvm_aggregate_profraws"
        "test_profdatas_to_lcov"
        "test_profraws_to_lcov"
        "test_wrong_binary_file"
      ];
    in
    builtins.map (x: "--skip=" + x) skipList;

  meta = {
    description = "Rust tool to collect and aggregate code coverage data for multiple source files";
    mainProgram = "grcov";
    homepage = "https://github.com/mozilla/grcov";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ DieracDelta ];
  };
})
