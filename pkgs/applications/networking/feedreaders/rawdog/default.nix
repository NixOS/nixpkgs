{ stdenv, fetchurl, pythonPackages }:

let version = "2.21"; in
pythonPackages.buildPythonPackage rec {
  name = "rawdog-${version}";

  src = fetchurl {
    url = "http://offog.org/files/${name}.tar.gz";
    sha256 = "0f5z7b70pyhjl6s28hgxninsr86s4dj5ycd50sv6bfz4hm1c2030";
  };

  propagatedBuildInputs = with pythonPackages; [ feedparser ];

  namePrefix = "";
  
  meta = with stdenv.lib; {
    inherit version;
    homepage = "http://offog.org/code/rawdog/";
    description = "RSS Aggregator Without Delusions Of Grandeur";
    license = licenses.gpl2;
    platform = platforms.unix;
    maintainers = with maintainers; [ nckx ];
  };
}
