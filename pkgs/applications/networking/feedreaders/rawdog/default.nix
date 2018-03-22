{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "rawdog-${version}";
  version = "2.22";

  src = fetchurl {
    url = "https://offog.org/files/${name}.tar.gz";
    sha256 = "01ircwl80xi5lamamsb22i7vmsh2ysq3chn9mbsdhqic2i32hcz0";
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
