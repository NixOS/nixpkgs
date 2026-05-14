{
  python3Packages,
  lib,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "snowmachine";
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-GhCfiMPEYa9EGCyVDncqKtLKpSN0SwIQ0XnmGEXBQ5I=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    colorama
    hatchling
  ];

  doCheck = false;
  pythonImportsCheck = [ "snowmachine" ];

  meta = {
    description = "Python script that will make your terminal snow";
    homepage = "https://github.com/sontek/snowmachine";
    mainProgram = "snowmachine";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [
      djanatyn
      sontek
    ];
  };
})
