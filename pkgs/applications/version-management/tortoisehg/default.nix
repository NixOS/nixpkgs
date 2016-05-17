{lib, fetchurl, mercurial, pythonPackages}:

pythonPackages.buildPythonApplication rec {
    name = "tortoisehg-${version}";
    version = "3.8.1";

    src = fetchurl {
      url = "https://bitbucket.org/tortoisehg/targz/downloads/${name}.tar.gz";
      sha256 = "1v5h5yz9b360ris9p8zsdjxqvaflp9z2b6b7dfb4abn2irv3jip6";
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
