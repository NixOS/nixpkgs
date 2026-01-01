{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "frogmouth";
  version = "0.9.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "frogmouth";
    rev = "v${version}";
    hash = "sha256-0fcCON/M9JklE7X9aRfzTkEFG4ckJqLoQlYCSrWHHGQ=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    httpx
    textual
    typing-extensions
    xdg
  ];

  pythonRelaxDeps = [
    "httpx"
    "textual"
  ];

  pythonImportsCheck = [ "frogmouth" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Markdown browser for your terminal";
    mainProgram = "frogmouth";
    homepage = "https://github.com/Textualize/frogmouth";
    changelog = "https://github.com/Textualize/frogmouth/blob/${src.rev}/ChangeLog.md";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
