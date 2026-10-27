{
  lib,
  fetchFromGitHub,
  python3,
  libseccomp,
  nixosTests,
  testers,
  benchexec,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "benchexec";
  version = "3.35";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sosy-lab";
    repo = "benchexec";
    tag = finalAttrs.version;
    hash = "sha256-qYBSpDZqKBPiGkftjTVxVah+eS8NaAt9q0UEaara+iE=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  # NOTE: CPU Energy Meter is not added,
  # because BenchExec should call the wrapper configured
  # via `security.wrappers.cpu-energy-meter`
  # in `programs.cpu-energy-meter`, which will have the required
  # capabilities to access MSR.
  # If we add `cpu-energy-meter` here, BenchExec will instead call an executable
  # without `CAP_SYS_RAWIO` and fail.
  dependencies = with python3.pkgs; [
    coloredlogs
    lxml
    pystemd
    pyyaml
  ];

  makeWrapperArgs = [
    "--set-default"
    "LIBSECCOMP"
    "${lib.getLib libseccomp}/lib/libseccomp.so"
  ];

  passthru.tests =
    let
      testVersion =
        result:
        testers.testVersion {
          command = "${result} --version";
          package = benchexec;
        };
    in
    {
      nixos = nixosTests.benchexec;
      benchexec-version = testVersion "benchexec";
      runexec-version = testVersion "runexec";
      table-generator-version = testVersion "table-generator";
      containerexec-version = testVersion "containerexec";
    };

  meta = {
    description = "Framework for Reliable Benchmarking and Resource Measurement";
    homepage = "https://github.com/sosy-lab/benchexec";
    maintainers = with lib.maintainers; [ lorenzleutgeb ];
    license = lib.licenses.asl20;
    mainProgram = "benchexec";
  };
})
