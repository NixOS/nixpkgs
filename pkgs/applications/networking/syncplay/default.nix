{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "syncplay-${version}";
  version = "1.5.3";

  format = "other";

  src = fetchurl {
    url = https://github.com/Syncplay/syncplay/archive/v1.5.3.tar.gz;
    sha256 = "1yk0aajskhk6czpjshf9a9pzp3rafh5cgdcyyz8pwpk4ca9zyzfv";
  };

  propagatedBuildInputs = with python2Packages; [ pyside twisted ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  postInstall = ''
    mkdir -p $out/lib/python2.7/site-packages
    mv $out/lib/syncplay/syncplay $out/lib/python2.7/site-packages/
  '';

  meta = with stdenv.lib; {
    homepage = http://syncplay.pl/;
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ enzime ];
  };
}
