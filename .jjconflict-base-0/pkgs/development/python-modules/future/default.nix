{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
}:

buildPythonPackage rec {
  pname = "future";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vSloMJMHhh7a4UWKT4pPNZjAO+Q7l1IQdq6/XZTAewU=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [
    "future.builtins"
    "future.moves"
    "future.standard_library"
    "past.builtins"
    "past.translation"
  ];

  doCheck = false;

  meta = {
    changelog = "https://github.com/PythonCharmers/python-future/blob/v${version}/docs/whatsnew.rst";
    description = "Clean single-source support for Python 3 and 2";
    longDescription = ''
      python-future is the missing compatibility layer between Python 2 and
      Python 3. It allows you to use a single, clean Python 3.x-compatible
      codebase to support both Python 2 and Python 3 with minimal overhead.

      It provides future and past packages with backports and forward ports
      of features from Python 3 and 2. It also comes with futurize and
      pasteurize, customized 2to3-based scripts that helps you to convert
      either Py2 or Py3 code easily to support both Python 2 and 3 in a
      single clean Py3-style codebase, module by module.
    '';
    homepage = "https://python-future.org";
    downloadPage = "https://github.com/PythonCharmers/python-future/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prikhi ];
  };
}
