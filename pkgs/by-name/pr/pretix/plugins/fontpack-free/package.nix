{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretix-plugin-build,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pretix-fontpack-free";
  version = "1.11.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-fontpack-free";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eeU8awLf/PSsLuAOobZhXVyQ3KM7jOEIz1ZLt4eDxzQ=";
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
