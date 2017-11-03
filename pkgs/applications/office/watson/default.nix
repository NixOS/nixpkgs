{ stdenv, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "td-watson";
  name = "${pname}-${version}";
  version = "1.4.0";

  src = pythonPackages.fetchPypi {
    inherit version pname;
    sha256 = "1py0g4990jmvq0dn7jasda7f10kzr41bix46hnbyc1rshjzc17hq";
  };

  # uses tox, test invocation fails
  doCheck = true;
  checkPhase = ''
    py.test -vs tests
 '';
  checkInputs = with pythonPackages; [ py pytest pytest-datafiles mock pytest-mock pytestrunner ];
  propagatedBuildInputs = with pythonPackages; [ requests click arrow ];

  meta = with stdenv.lib; {
    homepage = https://tailordev.github.io/Watson/;
    description = "A wonderful CLI to track your time!";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner ] ;
  };
}