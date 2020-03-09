{ stdenv, python3 }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi requests;
in
buildPythonApplication rec {
  pname = "tzupdate";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12jvyza9pfhazkzq94nizacknnp32lf7kalrjmpz1z2bqqxhx0fm";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Update timezone information based on geoip";
    homepage = "https://github.com/cdown/tzupdate";
    maintainers = [ maintainers.michaelpj ];
    license = licenses.unlicense;
  };
}
