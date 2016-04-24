{lib, fetchurl, mercurial, pythonPackages}:

pythonPackages.buildPythonApplication rec {
    name = "tortoisehg-${version}";
    version = "3.7.3";

    src = fetchurl {
      url = "https://bitbucket.org/tortoisehg/targz/downloads/${name}.tar.gz";
      sha256 = "1vahiavpkf9ib2mx8z5i6f0kh072zycazmbrc4sl94p5pvv5w1dh";
    };

    pythonPath = with pythonPackages; [ pyqt4 mercurial qscintilla iniparse ];

    propagatedBuildInputs = with pythonPackages; [ qscintilla iniparse ];

    doCheck = false;
    dontStrip = true;
    buildPhase = "";
    installPhase = ''
      ${pythonPackages.python.executable} setup.py install --prefix=$out
      ln -s $out/bin/thg $out/bin/tortoisehg     #convenient alias
    '';

    meta = {
      description = "Qt based graphical tool for working with Mercurial";
      homepage = http://tortoisehg.bitbucket.org/;
      license = lib.licenses.gpl2;
      platforms = lib.platforms.linux;
      maintainers = [ "abcz2.uprola@gmail.com" ];
    };
}
