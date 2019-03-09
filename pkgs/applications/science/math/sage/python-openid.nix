{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, django
, nose
, twill
, pycrypto
}:

buildPythonPackage rec {
  pname = "python-openid";
  version = "2.2.5";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vvhxlghjan01snfdc4k7ykd80vkyjgizwgg9bncnin8rqz1ricj";
  };

  propagatedBuildInputs = [
    pycrypto
  ];

  # Cannot access the djopenid example module.
  # I don't know how to fix that (adding the examples dir to PYTHONPATH doesn't work)
  doCheck = false;
  checkInputs = [ nose django twill ];
  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    description = "OpenID library for Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
    homepage = https://github.com/openid/python-openid/;
  };
}
