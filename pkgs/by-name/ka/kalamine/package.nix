{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kalamine";
  version = "0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OneDeadKey";
    repo = "kalamine";
    rev = "v${version}";
    hash = "sha256-SPXVFeysVF/6RqjhXmlPc+3m5vnVndJb7LQshQZBeg8=";
  };

  nativeBuildInputs = [
    python3.pkgs.hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    lxml
    pyyaml
    tomli
  ];

  pythonImportsCheck = [ "kalamine" ];

  meta = with lib; {
    description = "Keyboard Layout Maker";
    homepage = "https://github.com/OneDeadKey/kalamine/";
    license = licenses.mit;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "kalamine";
  };
}
