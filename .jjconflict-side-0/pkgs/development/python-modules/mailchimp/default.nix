{
  lib,
  buildPythonPackage,
  fetchPypi,
  docopt,
  requests,
}:

buildPythonPackage rec {
  version = "2.0.10";
  format = "setuptools";
  pname = "mailchimp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5227999904233a7d2e9ce5eac5225b9a5fac0318ae5107e3ed09c8bf89286768";
  };

  buildInputs = [ docopt ];
  propagatedBuildInputs = [ requests ];
  patchPhase = ''
    sed -i 's/==/>=/' setup.py
  '';

  meta = with lib; {
    description = "CLI client and Python API library for the MailChimp email platform";
    homepage = "http://apidocs.mailchimp.com/api/2.0/";
    license = licenses.mit;
  };
}
