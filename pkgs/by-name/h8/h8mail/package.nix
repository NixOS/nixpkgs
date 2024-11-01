{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "h8mail";
  version = "2.5.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "khast3x";
    repo = "h8mail";
    rev = "refs/tags/${version}";
    hash = "sha256-gKRght/12apPD1u3mRY/yCPT0XAyXwaYgaqyJHrDLgw=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
  ];

  pythonImportsCheck = [ "h8mail" ];

  meta = with lib; {
    description = "Email OSINT & Password breach hunting tool";
    homepage = "https://github.com/khast3x/h8mail";
    changelog = "https://github.com/khast3x/h8mail/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "h8mail";
  };
}
