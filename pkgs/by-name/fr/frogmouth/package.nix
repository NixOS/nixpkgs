{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "frogmouth";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "frogmouth";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "Markdown browser for your terminal";
    mainProgram = "frogmouth";
    homepage = "https://github.com/Textualize/frogmouth";
    changelog = "https://github.com/Textualize/frogmouth/blob/${finalAttrs.src.rev}/ChangeLog.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
