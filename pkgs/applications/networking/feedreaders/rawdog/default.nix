{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "rawdog-2.20";

  src = fetchurl {
    url = "http://offog.org/files/${name}.tar.gz";
    sha256 = "0a63b26cc111b0deca441f498177b49be0330760c5c0e24584cdb9ba1e7fd5a6";
  };

  propagatedBuildInputs = with pythonPackages; [ feedparser ];

  namePrefix = "";
  
  meta = {
    homepage = "http://offog.org/code/rawdog/";
    description = "an RSS Aggregator Without Delusions Of Grandeur.";
    license = stdenv.lib.licenses.gpl2;
    platform = stdenv.lib.platforms.unix;
  };
}
