{ stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, flask
}:

buildPythonPackage rec {
  pname = "Flask-OldSessions";
  version = "0.10";

  # no artifact on pypi: https://github.com/mitsuhiko/flask-oldsessions/issues/1
  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "flask-oldsessions";
    rev = version;
    sha256 = "04b5m8njjiwld9a0zw55iqwvyjgwcpdbhz1cic8nyhgcmypbicqn";
  };

  propagatedBuildInputs = [
    flask
  ];

  # missing module flask.testsuite, probably assumes an old version of flask
  doCheck = false;
  checkPhase = ''
    ${python.interpreter} run-tests.py
  '';

  meta = with stdenv.lib; {
    description = "Provides a session class that works like the one in Flask before 0.10.";
    license = licenses.bsd2;
    maintainers = with maintainers; [ timokau ];
    homepage = https://github.com/mitsuhiko/flask-oldsessions;
  };
}
