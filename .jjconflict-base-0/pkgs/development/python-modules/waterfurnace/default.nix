{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  requests,
  pythonOlder,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "waterfurnace";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sdague";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "1ba247fw1fvi7zy31zj2wbjq7fajrbxhp139cl9jj67rfvxfv8xf";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    click
    requests
    websocket-client
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "waterfurnace" ];

  meta = with lib; {
    description = "Python interface to waterfurnace geothermal systems";
    mainProgram = "waterfurnace-debug";
    homepage = "https://github.com/sdague/waterfurnace";
    changelog = "https://github.com/sdague/waterfurnace/blob/v${version}/HISTORY.rst";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
