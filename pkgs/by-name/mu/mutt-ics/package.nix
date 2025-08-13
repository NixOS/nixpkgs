{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mutt-ics";
  version = "0.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "mutt_ics";
    sha256 = "d44d4bec4e71c7f14df01b90fdb9563cdc784ece4250abfea5b0b675cfe85a50";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ icalendar ];

  pythonImportsCheck = [ "mutt_ics" ];

  meta = with lib; {
    homepage = "https://github.com/dmedvinsky/mutt-ics";
    description = "Tool to show calendar event details in Mutt";
    mainProgram = "mutt-ics";
    license = licenses.mit;
    maintainers = with maintainers; [ mh182 ];
  };
}
