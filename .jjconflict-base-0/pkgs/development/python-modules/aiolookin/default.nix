{
  lib,
  aiohttp,
  buildPythonPackage,
  faker,
  fetchFromGitHub,
  pytest-aiohttp,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiolookin";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ANMalko";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-G3/lUgV60CMLskUo83TlvLLIfJtu5DEz+94mdVI4OrI=";
  };

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    faker
    pytest-aiohttp
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # Not all tests are ready yet
    "test_successful"
  ];

  pythonImportsCheck = [ "aiolookin" ];

  meta = with lib; {
    description = "Python client for interacting with LOOKin devices";
    homepage = "https://github.com/ANMalko/aiolookin";
    changelog = "https://github.com/ANMalko/aiolookin/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
