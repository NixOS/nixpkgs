{ stdenv, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "0.15.3";
  pname = "homely";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "2aa7461b583660bf8d9ad776c184fa7a1272141a5c0faaf78a76bc3e8c39db6d";
  };

  buildInputs = with pythonPackages; [ attrs setuptools_scm ];
  propagatedBuildInputs = with pythonPackages; [
    requests
    simplejson
    click
    pythondaemon
  ];

  meta = with stdenv.lib; {
    description = "Dotfile management utility written in python";
    license = licenses.mit;
    homepage = "https://homely.readthedocs.io";
    maintainers = [ maintainers.lokke ];
  };
}
