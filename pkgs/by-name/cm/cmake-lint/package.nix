{
  lib,
  fetchFromGitHub,
  python3Packages,
  testers,
  cmake-lint,
}:

python3Packages.buildPythonApplication rec {
  pname = "cmake-lint";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cmake-lint";
    repo = "cmake-lint";
    rev = "refs/tags/${version}";
    hash = "sha256-/OuWwerBlJynEibaYo+jkLpHt4x9GZrqMRJNxgrDBlM=";
  };

  build-system = [ python3Packages.setuptools ];

  pythonImportsCheck = [ "cmakelint" ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    python3Packages.pytest-cov-stub
  ];

  passthru.tests = {
    version = testers.testVersion { package = cmake-lint; };
  };

  meta = {
    description = "Static code checker for CMake files";
    homepage = "https://github.com/cmake-lint/cmake-lint";
    changelog = "https://github.com/cmake-lint/cmake-lint/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    mainProgram = "cmakelint";
  };
}
