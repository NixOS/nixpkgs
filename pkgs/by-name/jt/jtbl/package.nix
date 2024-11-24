{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "jtbl";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = "jtbl";
    rev = "v${version}";
    hash = "sha256-ILQwUpjNueaYR5hxOWd5kZSPhVoFnnS2FcttyKSTPr8=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    tabulate
  ];

  pythonImportsCheck = [ "jtbl" ];

  meta = {
    description = "CLI tool to convert JSON and JSON Lines to terminal, CSV, HTTP, and markdown tables";
    homepage = "https://kellyjonbrazil.github.io/jtbl";
    downloadPage = "https://github.com/kellyjonbrazil/jtbl/releases/tag/${src.rev}";
    changelog = "https://github.com/kellyjonbrazil/jtbl/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ElliottSullingeFarrall ];
    mainProgram = "jtbl";
  };
}
