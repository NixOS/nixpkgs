{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "syncplay-${version}";
  version = "1.5.5";

  format = "other";

  src = fetchurl {
    url = https://github.com/Syncplay/syncplay/archive/v1.5.5.tar.gz;
    sha256 = "0g12hm84c48fjrmwljl0ii62f55vm6fk2mv8vna7fadabmk6dwhr";
  };

  propagatedBuildInputs = with python2Packages; [ pyside twisted ];

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://syncplay.pl/;
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ enzime ];
  };
}
