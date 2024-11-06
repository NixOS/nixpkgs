{
  lib,
  python3Packages,
  fetchPypi,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "ghstack";
  version = "0.9.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DgJOju8y66CXB1rn28fcrCIhRZiLlqPEw8S4+aO/8ss=";
  };

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    aiohttp
    click
    flake8
    requests
    typing-extensions
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Conveniently submit stacks of diffs to GitHub as separate pull requests";
    homepage = "https://pypi.org/project/ghstack";
    license = licenses.mit;
    sourceProvenance = [ sourceTypes.fromSource ];
    maintainers = with maintainers; [ aftix ];
    mainProgram = "ghstack";
    platforms = platforms.all;
  };
}
