{ stdenv, python }:

let
  inherit (python.pkgs) buildPythonApplication fetchPypi requests;
in
buildPythonApplication rec {
  pname = "tzupdate";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wj2r1wirnn5kllaasdldimvp3cc3w7w890iqrjksz5wwjbnj8pk";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Update timezone information based on geoip.";
    homepage = https://github.com/cdown/tzupdate;
    maintainers = [ maintainers.michaelpj ];
    license = licenses.unlicense;
  };
}
