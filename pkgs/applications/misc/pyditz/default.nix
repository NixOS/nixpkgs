{ stdenv, pythonPackages }:

with pythonPackages;

let
  cerberus_1_1 = callPackage ./cerberus.nix { };
in buildPythonApplication rec {
  pname = "pyditz";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hxxz7kxv9gsrr86ccsc31g7bc2agw1ihbxhd659c2m6nrqq5qaf";
  };
  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ pyyaml six jinja2 cerberus_1_1 ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    homepage = "https://pythonhosted.org/pyditz/";
    description = "Drop-in replacement for the Ditz distributed issue tracker";
    maintainers = [ maintainers.ilikeavocadoes ];
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
