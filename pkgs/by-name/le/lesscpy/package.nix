{
  lib,
  python3Packages,
  fetchPypi,
  fetchpatch,
}:

python3Packages.buildPythonPackage rec {
  pname = "lesscpy";
  version = "0.15.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EEXRepj2iGRsp1jf8lTm6cA3RWSOBRoIGwOVw7d8gkw=";
  };

  patches = [
    # remove use of pkg_resources (drop on next release)
    (fetchpatch {
      url = "https://github.com/lesscpy/lesscpy/commit/bd8949579713c9d4ff9e15799a26fcecdf73530e.patch";
      hash = "sha256-U1VDqZqHYaUmND5qCkARyU/eDv2QRhGcCDzuN4+XTbo=";
    })
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    ply
    six
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "lesscpy" ];

  meta = {
    description = "Python LESS Compiler";
    mainProgram = "lesscpy";
    homepage = "https://github.com/lesscpy/lesscpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ s1341 ];
  };
}
