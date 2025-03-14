{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "nbmerge";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jbn";
    repo = "nbmerge";
    tag = "v${version}";
    hash = "sha256-Uqs/SO/AculHCFYcbjW08kLQX5GSU/eAwkN2iy/vhLM=";
  };

  patches = [ ./pytest-compatibility.patch ];

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.nbformat ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  postCheck = ''
    patchShebangs .
    PATH=$PATH:$out/bin ./cli_tests.sh
  '';

  pythonImportsCheck = [ "nbmerge" ];

  meta = {
    description = "Tool to merge/concatenate Jupyter (IPython) notebooks";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "nbmerge";
  };
}
