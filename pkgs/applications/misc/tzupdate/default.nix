{ stdenv, python }:

let
  inherit (python.pkgs) buildPythonApplication fetchPypi requests;
in
buildPythonApplication rec {
  pname = "tzupdate";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sc3z2bx2nhnxg82x0jy19pr8lw56chbr90c2lr11w495csqwhz7";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Update timezone information based on geoip.";
    homepage = https://github.com/cdown/tzupdate;
    maintainers = [ maintainers.michaelpj ];
    license = licenses.unlicense;
  };
}
