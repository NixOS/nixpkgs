{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colorama,
  pytest,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-resource-path";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yukihiko-shinoda";
    repo = "pytest-resource-path";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y/mB5Gmkt3Rt8rRBOFZrWIREnpEiSxf/MChqymXDNws=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_resource_path" ];

  meta = {
    description = "Pytest plugin to provide path for uniform access to test resources";
    homepage = "https://github.com/yukihiko-shinoda/pytest-resource-path";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
