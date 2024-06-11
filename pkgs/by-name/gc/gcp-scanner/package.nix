{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gcp-scanner";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "gcp_scanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-6bIrSaTqpXQjB64YWAI64DlgQBD2XD+zMvKymMtwpDk=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-git-versioning
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    google-api-python-client
    google-cloud-container
    google-cloud-iam
    httplib2
    pyu2f
    requests
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gcp_scanner"
  ];

  disabledTests = [
    # Tests require credentials
    "TestCrawler"
    "test_acceptance"
  ];

  meta = with lib; {
    description = "Comprehensive scanner for Google Cloud";
    homepage = "https://github.com/google/gcp_scanner";
    changelog = "https://github.com/google/gcp_scanner/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "gcp-scanner";
  };
}
