{ pkgs, lib, mercurial, pyPackages ? pkgs.python27Packages }:

pkgs.buildPythonPackage rec {
    name = "tortoisehg-${version}";
    version = "3.4.2";
    namePrefix = "";

    src = pkgs.fetchurl {
      url = "https://bitbucket.org/tortoisehg/targz/downloads/${name}.tar.gz";
      sha256 = "18a587c8fybfjxbcj8i2smypxy7vfzmmrzibs74n3zy6dlb949nj";
    };

    pythonPath = [ pkgs.pyqt4 mercurial ]
       ++ (with pyPackages; [qscintilla iniparse]);

    propagatedBuildInputs = with pyPackages; [ qscintilla iniparse ];
    
    doCheck = false;

    postUnpack = ''
     substituteInPlace $sourceRoot/setup.py \
       --replace "/usr/share/" "$out/share/"
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