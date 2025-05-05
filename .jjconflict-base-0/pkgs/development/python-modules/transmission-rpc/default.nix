{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
  python-dotenv,
  pytz,
  requests,
  typing-extensions,
  yarl,
}:

buildPythonPackage rec {
  pname = "transmission-rpc";
  version = "7.0.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Trim21";
    repo = "transmission-rpc";
    tag = "v${version}";
    hash = "sha256-t07TuLLHfbxvWh+7854OMigfGC8jHzvpd4QO3v0M15I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    python-dotenv
    pytz
    pytestCheckHook
    yarl
  ];

  pythonImportsCheck = [ "transmission_rpc" ];

  disabledTests = [
    # Tests require a running Transmission instance
    "test_groups"
    "test_real"
  ];

  meta = with lib; {
    description = "Python module that implements the Transmission bittorent client RPC protocol";
    homepage = "https://github.com/Trim21/transmission-rpc";
    changelog = "https://github.com/trim21/transmission-rpc/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
