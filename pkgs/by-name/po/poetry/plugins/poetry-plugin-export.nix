{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry,
  poetry-core,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "poetry-plugin-export";
  version = "1.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    tag = version;
    hash = "sha256-AP3/njzbLEi2s4pOUSLLLzqNprvxwLe9LSY7qh08EWc=";
  };

  patches = [
    # Remove after next release of poetry-plugin-export
    (fetchpatch {
      url = "https://github.com/python-poetry/poetry-plugin-export/commit/16637f194e86708913ec6e09064c713eb0715bb6.patch";
      includes = [
        "tests/test_exporter.py"
        "tests/markers.py"
      ];
      hash = "sha256-ncz9kqp18+yeRXlhmLEcWfO1bDavjohhmVw6DwTy1hA=";
    })
  ];

  build-system = [
    poetry-core
  ];

  buildInputs = [
    poetry
  ];

  nativeCheckInputs = [
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/python-poetry/poetry-plugin-export/blob/${src.rev}/CHANGELOG.md";
    description = "Poetry plugin to export the dependencies to various formats";
    license = licenses.mit;
    homepage = "https://github.com/python-poetry/poetry-plugin-export";
    maintainers = [ ];
  };
}
