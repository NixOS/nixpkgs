{
  lib,
  fetchPypi,
  python3,
}:

let
  pname = "redfishtool";
  version = "1.1.8";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X/G6osOHCBidKZG/Y2nmHadifDacJhjBIc7WYrUCPn8=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    python-dateutil
  ];

  pythonImportsCheck = [ "redfishtoollib" ];

  meta = {
    description = "Python34 program that implements a command line tool for accessing the Redfish API";
    homepage = "https://github.com/DMTF/Redfishtool";
    changelog = "https://github.com/DMTF/Redfishtool/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jfvillablanca ];
    mainProgram = "redfishtool";
  };
}
