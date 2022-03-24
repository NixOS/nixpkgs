{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "kicost";
  version = "1.1.15";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-JPwhE3qew0DzBHVfVuQyW5tLJE6QNBE2P2x34WDSaUc=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    lxml
    XlsxWriter
    tqdm
    requests
    validators
    wxPython_4_1
    colorama
    pyyaml
    kicost-digikey-api-v3
  ];

  # Test artifacts missing in source distribution
  doCheck = false;
  pythonImportsCheck = [ "kicost" ];

  meta = with lib; {
    description = "Build cost spreadsheet for a KiCad project";
    homepage = "https://hildogjr.github.io/KiCost";
    license = licenses.mit;
    maintainers = with maintainers; [ sephalon ];
  };
}
