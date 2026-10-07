{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools_80,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "zope-event";
  version = "6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.event";
    tag = finalAttrs.version;
    hash = "sha256-FoE9bdr/JcOaB8/OQTUmxGrNgIDc1vPDlmZq0v+bjmQ=";
  };

  build-system = [ setuptools_80 ];

  pythonImportsCheck = [ "zope.event" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/zope/event/tests.py" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    description = "Event publishing system";
    homepage = "https://github.com/zopefoundation/zope.event";
    changelog = "https://github.com/zopefoundation/zope.event/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
})
