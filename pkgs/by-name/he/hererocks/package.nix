{
  lib,
  fetchPypi,
  python3Packages,
  gcc,
  git,
}:
let
  pname = "hererocks";
  version = "0.25.1";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qItzaTz3dTz35BOSR6gfA8cbrEywNfXWv+INzd2G0QA=";
  };

  propagatedBuildInputs = [
    gcc
    git
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Tool for installing Lua and LuaRocks locally";
    homepage = "https://github.com/luarocks/hererocks";
    changelog = "https://github.com/luarocks/hererocks/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "hererocks";
  };
}
