{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "elfdeps";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-wheel-build";
    repo = "elfdeps";
    tag = finalAttrs.version;
    hash = "sha256-mQAFU87OEA4ZjfsOAnSFaoOIez7dss3x35fTDdTnm10=";
  };

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  dependencies = [ python3Packages.pyelftools ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  pythonImportsCheck = [
    "elfdeps"
  ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  # tests assume that sys.executable is an ELF object
  doCheck = stdenv.hostPlatform.isElf;

  disabledTests = [
    # Attempts to zip sys.executable and fails with:
    # ValueError: ZIP does not support timestamps before 1980
    "test_main_zipfile"
    "test_zipmember_python"
  ];

  meta = {
    description = "Python implementation of RPM elfdeps";
    homepage = "https://pypi.org/project/elfdeps/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ booxter ];
    mainProgram = "elfdeps";
  };
})
