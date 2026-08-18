{
  lib,
  python3Packages,
  fetchFromGitHub,
  addBinToPathHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "eliot-tree";
  version = "24.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jonathanj";
    repo = "eliottree";
    tag = finalAttrs.version;
    hash = "sha256-4P6eAhX7XBuxu8r/7xvm07u4PZzKP3YLj/5kekgYXG8=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    colored
    eliot
    iso8601
    jmespath
    six
    toolz
  ];

  nativeCheckInputs = with python3Packages; [
    addBinToPathHook
    pytestCheckHook
    testtools
  ];

  pythonImportsCheck = [ "eliottree" ];

  meta = {
    homepage = "https://github.com/jonathanj/eliottree";
    changelog = "https://github.com/jonathanj/eliottree/blob/${finalAttrs.version}/NEWS.rst";
    description = "Render Eliot logs as an ASCII tree";
    mainProgram = "eliot-tree";
    license = lib.licenses.mit;
  };
})
