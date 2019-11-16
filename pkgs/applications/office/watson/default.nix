{ stdenv, pythonPackages, fetchpatch }:

with pythonPackages;

buildPythonApplication rec {
  pname = "watson";
  version = "1.8.0";

  src = fetchPypi {
    inherit version;
    pname = "td-watson";
    sha256 = "1ip66jhbcqifdw1avbhngwym0vv7fsqxgbph11da5wlqwfwp060n";
  };

  checkPhase = ''
    pytest -vs tests
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
