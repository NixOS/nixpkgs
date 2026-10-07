{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  regex,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "rebulk";
  version = "6.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-1t8MjIluFgCHxpgfN3DtUT7Jc6n0BmueSwYU6wi6DOE=";
  };

  build-system = [ uv-build ];

  dependencies = [ regex ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rebulk" ];

  meta = {
    description = "Advanced string matching from simple patterns";
    homepage = "https://github.com/Toilal/rebulk/";
    changelog = "https://github.com/Toilal/rebulk/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
