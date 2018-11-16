{ stdenv, python }:

let
  inherit (python.pkgs) buildPythonApplication fetchPypi requests;
in
buildPythonApplication rec {
  pname = "tzupdate";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "085kp4v9ijhkfvr0r5rzn4z7nrkb2qig05j0bajb0gkgynwf8wnz";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Update timezone information based on geoip.";
    homepage = https://github.com/cdown/tzupdate;
    maintainers = [ maintainers.michaelpj ];
    license = licenses.unlicense;
  };
}
