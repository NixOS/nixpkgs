{ stdenv, python }:

let
  inherit (python.pkgs) buildPythonApplication fetchPypi requests;
in
buildPythonApplication rec {
  pname = "tzupdate";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13np40h64bgkcj10qw6f4nb51p47bb20fd6pzxq8xbr645a4d34m";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Update timezone information based on geoip.";
    homepage = https://github.com/cdown/tzupdate;
    maintainers = [ maintainers.michaelpj ];
    license = licenses.unlicense;
  };
}
