{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "h5glance";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "European-XFEL";
    repo = "h5glance";
    tag = version;
    hash = "sha256-20gSaNZrH3AeFTGLho6sbWljfqln9SQEVdvEVe/WaYY=";
  };

  build-system = [
    python3.pkgs.flit-core
  ];

  dependencies = with python3.pkgs; [
    h5py
    htmlgen
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
  ];

  pythonImportsCheck = [
    "h5glance"
  ];

  meta = {
    description = "Explore HDF5 files in terminal & HTML views";
    homepage = "https://github.com/European-XFEL/h5glance";
    changelog = "https://github.com/European-XFEL/h5glance/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "h5glance";
  };
}
