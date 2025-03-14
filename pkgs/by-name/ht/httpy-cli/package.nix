{
  lib,
  python3Packages,
  fetchPypi,
  curl,
}:

python3Packages.buildPythonPackage rec {
  pname = "httpy-cli";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "httpy-cli";
    hash = "sha256-uhF/jF4buHMDiXOuuqjskynioz4qVBevQhdcUbH+91Q=";
  };

  propagatedBuildInputs = with python3Packages; [
    colorama
    pygments
    requests
    urllib3
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  pythonImportsCheck = [
    "httpy"
  ];

  nativeCheckInputs = [
    python3Packages.pytest
    curl
  ];

  checkPhase = ''
    runHook preCheck
    echo "line1\nline2\nline3" > tests/test_file.txt
    # ignore the test_args according to pytest.ini in the repo
    pytest tests/ --ignore=tests/test_args.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Modern, user-friendly, programmable command-line HTTP client for the API";
    homepage = "https://github.com/knid/httpy";
    license = licenses.mit;
    mainProgram = "httpy";
    maintainers = with maintainers; [ eymeric ];
  };
}
