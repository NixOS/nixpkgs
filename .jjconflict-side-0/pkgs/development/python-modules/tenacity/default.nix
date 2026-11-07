{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  tornado,
  typeguard,
}:

buildPythonPackage (finalAttrs: {
  pname = "tenacity";
  version = "9.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jd";
    repo = "tenacity";
    tag = finalAttrs.version;
    hash = "sha256-FuHzvj5E4GTUjDVQrM0nIapsj5P12p7pClwqJZLlq94=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    tornado
    typeguard
  ];

  pythonImportsCheck = [ "tenacity" ];

  meta = {
    homepage = "https://github.com/jd/tenacity";
    changelog = "https://github.com/jd/tenacity/releases/tag/${finalAttrs.src.tag}";
    description = "Retrying library for Python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jakewaksbaum ];
  };
})
