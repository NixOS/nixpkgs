{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "kicost";
  version = "1.1.18";

  src = fetchFromGitHub {
    owner = "hildogjr";
    repo = "KiCost";
    rev = "v${version}";
    hash = "sha256-mU8drY0D+zTGlrmvK/80in3QsXI8tgLSUKl3eFpaHS8=";
    fetchSubmodules = true;
  };

  dependencies = with python3.pkgs; [
    beautifulsoup4
    lxml
    xlsxwriter
    tqdm
    requests
    validators
    wxpython
    colorama
    pyyaml
    kicost-digikey-api-v3
  ];

  doCheck = true;
  pythonImportsCheck = [ "kicost" ];

  meta = with lib; {
    description = "Build cost spreadsheet for a KiCad project";
    homepage = "https://hildogjr.github.io/KiCost";
    license = licenses.mit;
    maintainers = with maintainers; [ sephalon ldenefle ];
    mainProgram = "kicost";
  };
}
