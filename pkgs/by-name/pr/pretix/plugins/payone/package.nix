{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretix-plugin-build,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pretix-payone";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-payone";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8DXORej+OJ65l/KGcanavHU4rabK9qTSnRPbdCidkgQ=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pretix_payone"
  ];

  meta = {
    description = "Pretix payment plugin for PAYONE";
    homepage = "https://github.com/pretix/pretix-payone";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
