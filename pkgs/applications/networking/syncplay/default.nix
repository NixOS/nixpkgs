{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "syncplay-${version}";
  version = "1.6.1";

  format = "other";

  src = fetchurl {
    url = https://github.com/Syncplay/syncplay/archive/v1.6.1.tar.gz;
    sha256 = "15rhbc3r7l012d330hb64p8bhcpy4ydy89iv34c34a1r554b8k97";
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
