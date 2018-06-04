{lib, fetchurl, mercurial, python2Packages}:

python2Packages.buildPythonApplication rec {
    name = "tortoisehg-${version}";
    version = "4.5.3";

    src = fetchurl {
      url = "https://bitbucket.org/tortoisehg/targz/downloads/${name}.tar.gz";
      sha256 = "1lfv3v9a0azdgixspacqamdv0fmf4d7cvh796i6qiv9qnc65xj97";
    };

    pythonPath = with python2Packages; [ pyqt4 mercurial qscintilla iniparse ];

    propagatedBuildInputs = with python2Packages; [ qscintilla iniparse ];

    doCheck = false; # tests fail with "thg: cannot connect to X server"
    dontStrip = true;
    buildPhase = "";
    installPhase = ''
      ${python2Packages.python.executable} setup.py install --prefix=$out
      mkdir -p $out/share/doc/tortoisehg
      cp COPYING.txt $out/share/doc/tortoisehg/Copying.txt.gz
      ln -s $out/bin/thg $out/bin/tortoisehg     #convenient alias
    '';

    checkPhase = ''
      echo "test: thg version"
      $out/bin/thg version
    '';

    meta = {
      description = "Qt based graphical tool for working with Mercurial";
      homepage = http://tortoisehg.bitbucket.org/;
      license = lib.licenses.gpl2;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ danbst ];
    };
}
