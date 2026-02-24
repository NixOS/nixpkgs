{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "elfdeps";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-wheel-build";
    repo = "elfdeps";
    tag = "v${version}";
    hash = "sha256-5CrxVmtZcBYBMXw7o58CpFopYFgXD4W/S42aow1z1Xw=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
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
}
