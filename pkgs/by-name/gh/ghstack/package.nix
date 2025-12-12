{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ghstack";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ezyang";
    repo = "ghstack";
    tag = version;
    hash = "sha256-pLKwDezkwGrqYgP4WnIl5nAam6bMNO6BK+xbxhp7Aq8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["uv_build>=0.6,<0.7"]' 'requires = ["uv_build>=0.6"]'
  '';

  build-system = [ python3.pkgs.uv-build ];

  dependencies = with python3.pkgs; [
    aiohttp
    click
    flake8
    importlib-metadata
    requests
    typing-extensions
  ];

  pythonImportsCheck = [ "ghstack.cli" ];

  meta = {
    description = "Submit stacked diffs to GitHub on the command line";
    homepage = "https://github.com/ezyang/ghstack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ munksgaard ];
    mainProgram = "ghstack";
  };
}
