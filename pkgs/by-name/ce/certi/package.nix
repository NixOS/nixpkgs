{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "certi";
  version = "0.1.0-unstable-2023-01-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zer1t0";
    repo = "certi";
    # https://github.com/zer1t0/certi/issues/6
    rev = "6cfa656c6c0fcbbe9b9bce847b052c881202354e";
    hash = "sha256-6j/Lwq68qyfEAo5MRibgdomrCO4KEd/DlAEwB+Z52Hc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cryptography
    impacket
  ];

  pythonImportsCheck = [
    "certilib"
  ];

  meta = with lib; {
    description = "ADCS abuser";
    homepage = "https://github.com/zer1t0/certi";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "certi";
  };
}
