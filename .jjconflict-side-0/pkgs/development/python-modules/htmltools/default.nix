{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  typing-extensions,
  pytestCheckHook,
  syrupy,
}:
buildPythonPackage (finalAttrs: {
  pname = "htmltools";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "py-htmltools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cs/aft5mghyRnMCeLrCMXRs3c5SmAZ/xPG0s7NBf8Yc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    packaging
    typing-extensions
  ];

  pythonImportsCheck = [ "htmltools" ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  meta = {
    description = "Tools for HTML generation and output";
    homepage = "https://github.com/posit-dev/py-htmltools";
    changelog = "https://github.com/posit-dev/py-htmltools/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
