{
  lib,
  python3,
  fetchPypi,
}:

let
  inherit (python3.pkgs) buildPythonApplication requests;
in
buildPythonApplication rec {
  pname = "tzupdate";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b55795c390e4ccc90e649c8cc387447daaf30a21d68f7196b49824cbcba8adc";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "Update timezone information based on geoip";
    mainProgram = "tzupdate";
    homepage = "https://github.com/cdown/tzupdate";
    maintainers = [ ];
    license = licenses.unlicense;
  };
}
