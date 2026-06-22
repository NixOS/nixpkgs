{
  lib,
  fetchPypi,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "psrecord";
  version = "1.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-WXcYVIi1ZwI5xziVGcqEy5BN3fEQH/825EWJjYcUVLE=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    psutil
    matplotlib
  ];

  nativeCheckInputs = with python3Packages; [
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    pytest psrecord
    runHook postCheck
  '';

  meta = {
    description = "Record the CPU and memory activity of a process";
    homepage = "https://github.com/astrofrog/psrecord";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ johnazoidberg ];
    mainProgram = "psrecord";
  };
})
