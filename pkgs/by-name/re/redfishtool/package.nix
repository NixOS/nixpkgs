{ lib
, fetchPypi
, python3
}:

let
  pname = "redfishtool";
  version = "1.1.8";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X/G6osOHCBidKZG/Y2nmHadifDacJhjBIc7WYrUCPn8=";
  };

  propagatedBuildInputs = with python3.pkgs; [ requests python-dateutil ];

  meta = with lib; {
    description = "A Python34 program that implements a command line tool for accessing the Redfish API";
    homepage = "https://github.com/DMTF/Redfishtool";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "redfishtool";
  };
}
