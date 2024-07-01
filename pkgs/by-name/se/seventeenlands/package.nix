{
  fetchPypi,
  lib,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "seventeenlands";
  version = "0.1.42";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P/imV4vvyd6wgjqXzgfIAURFtFhLwX1eS8eiPl79oZk=";
  };

  # No tests
  doCheck = false;

  propagatedBuildInputs = with python3.pkgs; [
    python-dateutil
    requests
    tkinter
  ];

  meta = with lib; {
    description = "Simple client for passing relevant events from MTG Arena logs to the 17Lands REST endpoint.";
    homepage = "https://www.17lands.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sephii ];
    mainProgram = "seventeenlands";
  };
}
