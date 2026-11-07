{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mmh3";
  version = "5.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hajimes";
    repo = "mmh3";
    tag = "v${version}";
    hash = "sha256-LAxaG0DiWAeymKX8Evl6or6zwO6jJk4D9SSO7wa47Ko=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "mmh3" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python wrapper for MurmurHash3, a set of fast and robust hash functions";
    homepage = "https://github.com/hajimes/mmh3";
    changelog = "https://github.com/hajimes/mmh3/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.cc0;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
