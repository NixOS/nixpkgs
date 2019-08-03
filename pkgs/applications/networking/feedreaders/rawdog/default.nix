{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "rawdog-${version}";
  version = "2.23";

  src = fetchurl {
    url = "https://offog.org/files/${name}.tar.gz";
    sha256 = "18nyg19mwxyqdnykplkqmzb4n27vvrhvp639zai8f81gg9vdbsjp";
  };

  propagatedBuildInputs = with python2Packages; [ feedparser ];

  namePrefix = "";

  meta = with stdenv.lib; {
    homepage = https://offog.org/code/rawdog/;
    description = "RSS Aggregator Without Delusions Of Grandeur";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
