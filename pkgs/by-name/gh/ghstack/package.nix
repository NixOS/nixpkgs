{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ghstack";
  version = "0.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ezyang";
    repo = "ghstack";
    rev = "0c412bf0d9515e11b58cddaeb1b1d9f0b17a5295";
    hash = "sha256-VDsYIeFL8U5anUJ9KtWhEUeuoaO2qu5K7lSnGTjxNGs=";
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
