{ fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "novaclient-2012.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/p/python-novaclient/python-${name}.tar.gz";
    md5 = "8f53a308e08b2af4645281917be77ffc";
  };

  pythonPath = [ pythonPackages.prettytable pythonPackages.argparse pythonPackages.httplib2 ];

  buildInputs = [ pythonPackages.mock pythonPackages.nose ];

  meta = {
    homepage = https://github.com/rackspace/python-novaclient;
    description = "Client library and command line tool for the OpenStack Nova API";
  };
}
