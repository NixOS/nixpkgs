{ lib
, python3
, fetchFromGitHub
, ghidra
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ghidriff";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clearbluejar";
    repo = "ghidriff";
    rev = "v${version}";
    hash = "sha256-6VcaJGycqSb6HwIBY+7Ki1Us9SBuVgyMJ6EsMwb+5ok=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.mdutils
    python3.pkgs.pyhidra
  ];

  makeWrapperArgs = [
    "--set GHIDRA_INSTALL_DIR ${ghidra}/lib/ghidra"
  ];

  pythonImportsCheck = [ "ghidriff" ];

  meta = with lib; {
    description = "Commandline binary diffing engine using Ghidra";
    homepage = "https://clearbluejar.github.io/ghidriff/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ evanrichter ];
    mainProgram = "ghidriff";
  };
}
