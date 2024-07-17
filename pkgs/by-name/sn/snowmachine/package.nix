{
  python3Packages,
  lib,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "snowmachine";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256:119e6da12f430af1519f1a9f091b77b7676c7a9dbeaab6616cb196fe793d8e61";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    colorama
    hatchling
  ];

  doCheck = false;
  pythonImportsCheck = [ "snowmachine" ];

  meta = with lib; {
    description = "A python script that will make your terminal snow";
    homepage = "https://github.com/sontek/snowmachine";
    mainProgram = "snowmachine";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [
      djanatyn
      sontek
    ];
  };
}
