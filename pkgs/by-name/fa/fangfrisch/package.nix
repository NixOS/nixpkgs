{ lib
, python3
, fetchFromGitHub
}:
let
  version = "1.8.1";
in
python3.pkgs.buildPythonApplication {
  pname = "fangfrisch";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rseichter";
    repo = "fangfrisch";
    rev = "refs/tags/${version}";
    hash = "sha256-j5IUAMDXndLttQZQV3SZXdDka8bKDcwbotY2Nop3izc=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    sqlalchemy
  ];

  pythonImportsCheck = [ "fangfrisch" ];

  meta = with lib; {
    description = "Update and verify unofficial Clam Anti-Virus signatures";
    homepage = "https://github.com/rseichter/fangfrisch";
    changelog = "https://github.com/rseichter/fangfrisch/blob/${version}/CHANGELOG.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "fangfrisch";
  };
}
