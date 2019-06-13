{lib, fetchurl, mercurial, python2Packages}:

python2Packages.buildPythonApplication rec {
    name = "tortoisehg-${version}";
    version = "4.9.1";

    src = fetchurl {
      url = "https://bitbucket.org/tortoisehg/targz/downloads/${name}.tar.gz";
      sha256 = "0c5gp5wyaiyh8w2zzy1q0f2qv8aa3219shb6swpsdzqr2j9gkk4b";
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
      homepage = https://tortoisehg.bitbucket.io/;
      license = lib.licenses.gpl2;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ danbst ];
    };
}
