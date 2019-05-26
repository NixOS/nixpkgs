{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "syncplay-${version}";
  version = "1.6.3";

  format = "other";

  src = fetchurl {
    url = https://github.com/Syncplay/syncplay/archive/v1.6.3.tar.gz;
    sha256 = "151p1njlp3dp3pfr3l3m6ia5829zvjyjh4p45j6rgnicbh8sqrgs";
  };

  propagatedBuildInputs = with python3Packages; [ pyside twisted ];

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://syncplay.pl/;
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ enzime ];
  };
}
