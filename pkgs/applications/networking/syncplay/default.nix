{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "syncplay-${version}";
  version = "1.5.4";

  format = "other";

  src = fetchurl {
    url = https://github.com/Syncplay/syncplay/archive/v1.5.4.tar.gz;
    sha256 = "10achpzmqn84mc0ds9cfjv794r4z55qdhbfpxa8212m2f3rga7iv";
  };

  propagatedBuildInputs = with python2Packages; [ pyside twisted ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  postInstall = ''
    mkdir -p $out/lib/python2.7/site-packages
    mv $out/lib/syncplay/syncplay $out/lib/python2.7/site-packages/
  '';

  meta = with stdenv.lib; {
    homepage = https://syncplay.pl/;
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ enzime ];
  };
}
