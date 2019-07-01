{ stdenv, pythonPackages, fetchpatch }:

with pythonPackages;

buildPythonApplication rec {
  pname = "td-watson";
  version = "1.7.0";

  src = fetchPypi {
    inherit version pname;
    sha256 = "249313996751f32f38817d424cbf8d74956461df1439f0ee3a962fcc3c77225d";
  };

  # uses tox, test invocation fails
  doCheck = true;
  checkPhase = ''
    py.test -vs tests
 '';

  checkInputs = [ py pytest pytest-datafiles mock pytest-mock pytestrunner ];
  propagatedBuildInputs = [ requests click arrow ];

  meta = with stdenv.lib; {
    homepage = https://tailordev.github.io/Watson/;
    description = "A wonderful CLI to track your time!";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner nathyong ] ;
  };
}
