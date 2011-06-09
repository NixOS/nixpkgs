{ fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "novaclient-2.4.3";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/p/python-novaclient/python-${name}.tar.gz";
    md5 = "c4be4adf371d1a84ce1581af365a53d0";
  };

  pythonPath = [ pythonPackages.prettytable pythonPackages.argparse pythonPackages.httplib2 pythonPackages.ssl ];

  buildInputs = [ pythonPackages.mock pythonPackages.nose ];

  meta = {
    homepage = https://github.com/rackspace/python-novaclient;
    description = "Client library and command line tool for the OpenStack Nova API";
  };
}
