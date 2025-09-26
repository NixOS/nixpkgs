{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "ghstack";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ezyang";
    repo = "ghstack";
    rev = "fa7e7023d798aad6b115b88c5ad67ce88a4fc2a6";
    hash = "sha256-Ywwjeupa8eE/vkrbl5SIbvQs53xaLnq9ieWRFwzmuuc=";
  };

  build-system = [ python3.pkgs.poetry-core ];

  dependencies = with python3.pkgs; [
    aiohttp
    click
    flake8
    importlib-metadata
    requests
    typing-extensions
  ];

  pythonImportsCheck = [ "ghstack" ];

  meta = {
    description = "Submit stacked diffs to GitHub on the command line";
    homepage = "https://github.com/ezyang/ghstack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ munksgaard ];
    mainProgram = "ghstack";
  };
}
