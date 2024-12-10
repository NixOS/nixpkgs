{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nginx-language-server";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pappasam";
    repo = "nginx-language-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-AXWrNt4f3jkAbidE1goDgFicu4sSBv08f/Igyh2bRII=";
  };

  build-system = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "pydantic"
  ];

  dependencies = with python3.pkgs; [
    crossplane
    lsprotocol
    pydantic
    pygls
  ];

  pythonImportsCheck = [ "nginx_language_server" ];

  meta = with lib; {
    description = "Language server for nginx.conf";
    homepage = "https://github.com/pappasam/nginx-language-server";
    changelog = "https://github.com/pappasam/nginx-language-server/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "nginx-language-server";
  };
}
