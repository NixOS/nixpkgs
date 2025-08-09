{
  python3Packages,
  lib,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "snowmachine";
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GhCfiMPEYa9EGCyVDncqKtLKpSN0SwIQ0XnmGEXBQ5I=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    colorama
    hatchling
  ];

  doCheck = false;
  pythonImportsCheck = [ "snowmachine" ];

  meta = with lib; {
    description = "Python script that will make your terminal snow";
    homepage = "https://github.com/sontek/snowmachine";
    mainProgram = "snowmachine";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [
      djanatyn
      sontek
    ];
  };
}
