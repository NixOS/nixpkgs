{
  fetchPypi,
  lib,
  python3,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "seventeenlands";
  version = "0.1.43";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-oTF4dtMKhx2YR80goKTcyq2P0mxAKLE2Ze5HbMNvyGg=";
  };

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "seventeenlands" ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    python-dateutil
    requests
    tkinter
  ];

  meta = {
    description = "Client for passing relevant events from MTG Arena logs to the 17Lands REST endpoint, also known as mtga-log-client";
    homepage = "https://www.17lands.com/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sephi ];
    mainProgram = "seventeenlands";
  };
})
