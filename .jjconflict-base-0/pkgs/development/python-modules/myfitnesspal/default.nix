{
  lib,
  blessed,
  browser-cookie3,
  buildPythonPackage,
  cloudscraper,
  fetchPypi,
  keyring,
  keyrings-alt,
  lxml,
  measurement,
  mock,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  rich,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "myfitnesspal";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H9oKSio+2x4TDCB4YN5mmERUEeETLKahPlW3TDDFE/E=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    blessed
    browser-cookie3
    cloudscraper
    keyring
    keyrings-alt
    lxml
    measurement
    python-dateutil
    requests
    rich
    typing-extensions
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    # Remove overly restrictive version constraints
    sed -i -e "s/>=.*//" requirements.txt

    # https://github.com/coddingtonbear/python-measurement/pull/8
    substituteInPlace tests/test_client.py \
      --replace-fail "Weight" "Mass" \
      --replace-fail '"Mass"' '"Weight"'
  '';

  disabledTests = [
    # Integration tests require an account to be set
    "test_integration"
  ];

  pythonImportsCheck = [ "myfitnesspal" ];

  meta = {
    description = "Python module to access meal tracking data stored in MyFitnessPal";
    mainProgram = "myfitnesspal";
    homepage = "https://github.com/coddingtonbear/python-myfitnesspal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
