{ stdenv
, buildPythonPackage
, fetchPypi
, flask
, python-openid
}:

buildPythonPackage rec {
  pname = "Flask-OpenID";
  version = "1.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aycwmwi7ilcaa5ab8hm0bp6323zl8z25q9ha0gwrl8aihfgx3ss";
  };

  propagatedBuildInputs = [
    flask
    python-openid
  ];

  meta = with stdenv.lib; {
    description = "Adds openid support to flask applications";
    license = licenses.bsd2;
    maintainers = with maintainers; [ timokau ];
    homepage = "https://pythonhosted.org/Flask-OpenID/";
  };
}
