{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  numpy,
  pytest-repeat,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "stringzilla";
  version = "5.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "stringzilla";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RENsISsEfDJaoQK9v9i6vM3OId7FREw5hixpEUETfEw=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "stringzilla" ];

  nativeCheckInputs = [
    numpy
    pytest-repeat
    pytestCheckHook
  ];

  disabledTestPaths = [
    # ignored in .github/workflows/prerelease.yml
    "test/stringzillas.py"
    "test/similarities.py"
    "test/fingerprints.py"
    "test/szs_helpers.py"
  ];

  meta = {
    changelog = "https://github.com/ashvardanian/StringZilla/releases/tag/${finalAttrs.src.tag}";
    description = "SIMD-accelerated string search, sort, hashes, fingerprints, & edit distances";
    homepage = "https://github.com/ashvardanian/stringzilla";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aciceri
      dotlambda
    ];
  };
})
