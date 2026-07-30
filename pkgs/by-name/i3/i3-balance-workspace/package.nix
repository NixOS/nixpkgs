{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "i3-balance-workspace";
  version = "1.8.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-zJdn/Q6r60FQgfehtQfeDkmN0Rz3ZaqgNhiWvjyQFy0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api' \
      --replace-fail 'poetry>=' 'poetry-core>='
  '';

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = [
    python3Packages.i3ipc
  ];

  doCheck = false; # project has no test
  pythonImportsCheck = [ "i3_balance_workspace" ];

  meta = {
    description = "Balance windows and workspaces in i3wm";
    homepage = "https://pypi.org/project/i3-balance-workspace/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euxane ];
    mainProgram = "i3_balance_workspace";
  };
})
