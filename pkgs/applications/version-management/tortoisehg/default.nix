{lib, fetchurl, mercurial, python2Packages}:

python2Packages.buildPythonApplication rec {
    name = "tortoisehg-${version}";
    version = "4.1.1";

    src = fetchurl {
      url = "https://bitbucket.org/tortoisehg/targz/downloads/${name}.tar.gz";
      sha256 = "14fy5p5hx4iij5kyma9679nrprd9lsjr6j047bfyfrwa3l4knj2g";
    };

    pythonPath = with python2Packages; [ pyqt4 mercurial qscintilla iniparse ];

    propagatedBuildInputs = with python2Packages; [ qscintilla iniparse ];

    doCheck = false;
    dontStrip = true;
    buildPhase = "";
    installPhase = ''
      ${python2Packages.python.executable} setup.py install --prefix=$out
      ln -s $out/bin/thg $out/bin/tortoisehg     #convenient alias
    '';

    meta = {
      description = "Qt based graphical tool for working with Mercurial";
      homepage = http://tortoisehg.bitbucket.org/;
      license = lib.licenses.gpl2;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ danbst ];
    };
}
