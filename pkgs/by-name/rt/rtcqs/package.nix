{
  lib,
  fetchPypi,
  python3,
}:

let
  pname = "rtcqs";
  version = "0.6.2";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  disabled = python3.pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DfeV9kGhdMf6hZ1iNJ0L3HUn7m8c1gRK5cjtJNUAvJI=";
  };

  build-system = with python3.pkgs; [ setuptools ];
  dependencies = with python3.pkgs; [
    tkinter
    pysimplegui
  ];

  meta = with lib; {
    description = "Utility to analyze and detect Linux audio bottlenecks on your system";
    homepage = "https://codeberg.org/rtcqs/rtcqs";
    license = licenses.mit;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "rtcqs";
  };
}
