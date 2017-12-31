{ stdenv, pythonPackages, fetchpatch }:

with pythonPackages;

buildPythonApplication rec {
  pname = "td-watson";
  version = "1.5.2";

  src = fetchPypi {
    inherit version pname;
    sha256 = "6e03d44a9278807fe5245e9ed0943f13ffb88e11249a02655c84cb86260b27c8";
  };

  # uses tox, test invocation fails
  doCheck = true;
  checkPhase = ''
    py.test -vs tests
 '';

  patches = [
    (fetchpatch {
      url = https://github.com/TailorDev/Watson/commit/f5760c71cbc22de4e12ede8f6f7257515a9064d3.patch;
      sha256 = "0s9h26915ilpbd0qhmvk77r3gmrsdrl5l7dqxj0l5q66fp0z6b0g";
    })
  ];

  checkInputs = [ py pytest pytest-datafiles mock pytest-mock pytestrunner ];
  propagatedBuildInputs = [ requests click arrow ];

  meta = with stdenv.lib; {
    homepage = https://tailordev.github.io/Watson/;
    description = "A wonderful CLI to track your time!";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner ] ;
  };
}
