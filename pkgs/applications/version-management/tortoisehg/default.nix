{lib, fetchurl, mercurial, pythonPackages}:

pythonPackages.buildPythonApplication rec {
    name = "tortoisehg-${version}";
    version = "3.7.1";
    namePrefix = "";

    src = fetchurl {
      url = "https://bitbucket.org/tortoisehg/targz/downloads/${name}.tar.gz";
      sha256 = "1ycf8knwk1rs99s5caq611sk4c4nzwyzq8g35hw5kwj15b6dl4k6";
    };

    pythonPath = with pythonPackages; [ pyqt4 mercurial qscintilla iniparse ];

    propagatedBuildInputs = with pythonPackages; [ qscintilla iniparse ];

    doCheck = false;

    postUnpack = ''
     substituteInPlace $sourceRoot/setup.py \
       --replace "sharedir = os.path.join(installcmd.install_data[rootlen:], 'share')" "sharedir = '$out/share/'"
    '';

    postInstall = ''
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
