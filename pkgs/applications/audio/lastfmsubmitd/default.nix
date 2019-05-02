{ lib, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "lastfmsubmitd";
  version = "1.0.6";

  src = fetchurl {
    url = "https://www.red-bean.com/decklin/lastfmsubmitd/lastfmsubmitd-${version}.tar.gz";
    sha256 = "c2636d5095a95167366bacd458624d67b046e060244fa54ba2c2e3efb79f9b0e";
  };

  doCheck = false;

  installCommand = "python setup.py install --prefix=$out";

  meta = {
    homepage = https://www.red-bean.com/decklin/lastfmsubmitd/;
    license = lib.licenses.mit;
    description = "An last.fm audio scrobbler and daemon";
  };
}
