{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  pybind11,
  unstableGitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "libparse-python";
  version = "0-unstable-2025-08-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "librelane";
    repo = "libparse-python";
    rev = "ff5b26da3d66affb60696fd6c4af7f8726729c8c";
    fetchSubmodules = true;
    hash = "sha256-H2UHh5RbxJ65yTbLybCEanl5qA4o0e/0rAQKmIhvXeQ=";
  };

  postPatch = ''
    substituteInPlace yosys/passes/techmap/libparse.cc \
        --replace-fail \
          "void LibertyParser::error" \
          "__attribute__((weak)) void LibertyParser::error"
  '';

  build-system = [
    pybind11
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "libparse" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Python library for parsing Yosys output";
    homepage = "https://github.com/librelane/libparse-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gonsolo ];
    platforms = lib.platforms.linux;
  };
})
