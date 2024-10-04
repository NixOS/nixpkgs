{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "steamctl";
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "steamctl";
    rev = "refs/tags/v${version}";
    hash = "sha256-reNch5MP31MxyaeKUlANfizOXZXjtIDeSM1kptsWqkc=";
  };

  build-system = with python3Packages; [ setuptools ];
  dependencies = with python3Packages; [
    steam
    appdirs
    argcomplete
    tqdm
    arrow
    pyqrcode
    vpk
    beautifulsoup4
  ];

  meta = {
    description = "A CLI utility to interface with Steam";
    homepage = "https://github.com/ValvePython/steamctl"; # GitHub's homepage is set to PyPi listing, PyPi listing's homepage is set to GitHub
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
