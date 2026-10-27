{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretix-plugin-build,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pretix-fontpack-free";
  version = "1.11.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-fontpack-free";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FXMzD1r5xegz10JbeXJDLy9oxUhAIjYknZz/y2Og4Dw=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  pythonImportsCheck = [
    "pretix_fontpackfree"
  ];

  meta = {
    description = "Set of free fonts for pretix";
    homepage = "https://github.com/pretix/pretix-fontpack-free";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
