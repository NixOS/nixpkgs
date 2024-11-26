{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  http-message-signatures,
  http-sfv,
  requests,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "requests-http-signature";
  version = "0.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sW2vYqT/nY27DvEKHdptc3dUpuqKmD7PLMs+Xp+cpeU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    http-message-signatures
    http-sfv
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "test/test.py" ];

  disabledTests = [
    # Test require network access
    "test_readme_example"
  ];

  pythonImportsCheck = [ "requests_http_signature" ];

  meta = with lib; {
    description = "Requests authentication module for HTTP Signature";
    homepage = "https://github.com/kislyuk/requests-http-signature";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmai ];
  };
}
