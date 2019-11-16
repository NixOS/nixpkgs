{ stdenv, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "pyditz";
  version = "0.10.3";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0hxxz7kxv9gsrr86ccsc31g7bc2agw1ihbxhd659c2m6nrqq5qaf";
  };
  nativeBuildInputs = [ pythonPackages.setuptools_scm ];
  propagatedBuildInputs = with pythonPackages; [ pyyaml six jinja2 cerberus11 ];

  checkPhase = ''
    ${pythonPackages.python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    homepage = https://pythonhosted.org/pyditz/;
    description = "Drop-in replacement for the Ditz distributed issue tracker";
    maintainers = [ maintainers.ilikeavocadoes ];
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
