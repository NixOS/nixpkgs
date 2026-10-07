{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  grequests,
  hawkauthlib,
  mock,
  pybrowserid,
  pyjwt,
  pytestCheckHook,
  requests,
  responses,
  hatchling,
  parameterized,
}:

buildPythonPackage rec {
  pname = "pyfxa";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a2BfT4Yq6OR0znESJoXB9eoELr5PHryW/+D4L3bFlV0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cryptography
    hawkauthlib
    pybrowserid
    pyjwt
    requests
  ];

  nativeCheckInputs = [
    grequests
    mock
    responses
    pytestCheckHook
    parameterized
  ];

  pythonImportsCheck = [ "fxa" ];

  disabledTestPaths = [
    # Requires network access
    "fxa/tests/test_core.py"
    "fxa/tests/test_oauth.py"
  ];

  meta = {
    description = "Firefox Accounts client library";
    mainProgram = "fxa-client";
    homepage = "https://github.com/mozilla/PyFxA";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
