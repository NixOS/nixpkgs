{ stdenv, fetchurl, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  name = "jrnl";
  version = "1.8.1";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/j/jrnl/${name}-${version}.tar.gz";
    sha256 = "bb47cc11d131ff337b5841952d71113291628efe3fbc00806f0bc58a9983fca8";
  };

  buildInputs = [
    pythonPackages.readline
    pythonPackages.parsedatetime
    pythonPackages.pytz
    pythonPackages.six
    pythonPackages.tzlocal
    pythonPackages.keyring
    pythonPackages.dateutil
  ];

  meta = {
    description = "A command line journal application that stores your journal in a plain text file";
    homepage = "http://maebert.github.io/jrnl";
    license = "MIT";
    platforms = stdenv.lib.platforms.unix;
  };
}
