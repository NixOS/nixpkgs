{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "rawdog-${version}";
  version = "2.21";

  src = fetchurl {
    url = "http://offog.org/files/${name}.tar.gz";
    sha256 = "0f5z7b70pyhjl6s28hgxninsr86s4dj5ycd50sv6bfz4hm1c2030";
  };

  propagatedBuildInputs = with python2Packages; [ feedparser ];

  namePrefix = "";

  meta = with stdenv.lib; {
    homepage = http://offog.org/code/rawdog/;
    description = "RSS Aggregator Without Delusions Of Grandeur";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nckx ];
  };
}
