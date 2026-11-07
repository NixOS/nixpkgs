{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  lxml,
  requests,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-netgear-plus";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "foxey";
    repo = "py-netgear-plus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UDy5kMfSrKXLsGTRLcYWqi7Mv1dtYSaIx+sy8PHipKE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    lxml
    requests
  ];

  pythonImportsCheck = [ "py_netgear_plus" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/foxey/py-netgear-plus/releases/tag/${finalAttrs.src.tag}";
    description = "Python Library for NETGEAR Plus Switches";
    homepage = "https://github.com/foxey/py-netgear-plus";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aiyion ];
  };
})
