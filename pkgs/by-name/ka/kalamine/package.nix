{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kalamine";
  version = "0.38";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OneDeadKey";
    repo = "kalamine";
    rev = "v${version}";
    hash = "sha256-eDOwoI7S0l48oOWWDaBbDlC0A8RtPEA+FDCHpPur0OQ=";
  };

  nativeBuildInputs = [
    python3.pkgs.hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    livereload
    lxml
    progress
    pyyaml
    tomli
  ];

  pythonImportsCheck = [ "kalamine" ];

<<<<<<< HEAD
  meta = {
    description = "Keyboard Layout Maker";
    homepage = "https://github.com/OneDeadKey/kalamine/";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Keyboard Layout Maker";
    homepage = "https://github.com/OneDeadKey/kalamine/";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "kalamine";
  };
}
