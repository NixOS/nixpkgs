{
  lib,
  python3Packages,
  fetchPypi,
  addBinToPathHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "eliot-tree";
  version = "21.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hTl+r+QJPPQ7ss73lty3Wm7DLy2SKGmmgIuJx38ilO8=";
  };

  # Patch Python 3.12 incompatibilities in versioneer.py.
  postPatch = ''
    substituteInPlace versioneer.py \
      --replace-fail SafeConfigParser ConfigParser \
      --replace-fail readfp read_file
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    colored
    eliot
    iso8601
    jmespath
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
