{ lib, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "rawdog";
  version = "2.23";

  src = fetchurl {
    url = "https://offog.org/files/${pname}-${version}.tar.gz";
    sha256 = "18nyg19mwxyqdnykplkqmzb4n27vvrhvp639zai8f81gg9vdbsjp";
  };

  propagatedBuildInputs = with python2Packages; [ feedparser ];

  # Requested by @SuperSandro20001
  pythonImportsCheck = [ "feedparser" ];
  doCheck = false;

  namePrefix = "";

  meta = with lib; {
    homepage = "https://offog.org/code/rawdog/";
    description = "RSS Aggregator Without Delusions Of Grandeur";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
