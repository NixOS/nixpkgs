{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hubfetch";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-L31RCunKz4elsGJL02oR1z8In1ge0LZ5RAA9X4jQhHk=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = [
    python3.pkgs.click
    python3.pkgs.requests
    python3.pkgs.rich
  ];

  doCheck = false;

  meta = {
    description = "A CLI ricing tool designed to fetch GitHub user stats";
    homepage = "https://github.com/PranavU-Coder/hubfetch";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "hubfetch";
  };
}
