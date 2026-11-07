{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aircot";
  version = "4.0.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snstac";
    repo = "aircot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9G3vHZ5TmFfE7O3TP+MWGHQgVBDJx/adEcQtjGZWqHs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aircot" ];

  meta = {
    description = "Display Ships in TAK - AIS to TAK Gateway";
    homepage = "https://aircot.rtfd.io";
    changelog = "https://github.com/snstac/aircot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
