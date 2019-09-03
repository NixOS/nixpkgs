{ lib, fetchurl, python2Packages
, mercurial
}@args:
let
  tortoisehgSrc = fetchurl rec {
    meta.name = "tortoisehg-${meta.version}";
    meta.version = "5.0.2";
    url = "https://bitbucket.org/tortoisehg/targz/downloads/${meta.name}.tar.gz";
    sha256 = "1fkawx4ymaacah2wpv2w7rxmv1mx08mg4x4r4fxh41jz1njjb8sz";
  };

  mercurial =
    if args.mercurial.meta.version == tortoisehgSrc.meta.version
      then args.mercurial
      else args.mercurial.override {
        mercurialSrc = fetchurl rec {
          meta.name = "mercurial-${meta.version}";
          meta.version = tortoisehgSrc.meta.version;
          url = "https://mercurial-scm.org/release/${meta.name}.tar.gz";
          sha256 = "1y60hfc8gh4ha9sw650qs7hndqmvbn0qxpmqwpn4q18z5xwm1f19";
        };
      };

in python2Packages.buildPythonApplication {

    inherit (tortoisehgSrc.meta) name version;
    src = tortoisehgSrc;

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

    passthru.mercurial = mercurial;

    meta = {
      description = "Qt based graphical tool for working with Mercurial";
      homepage = https://tortoisehg.bitbucket.io/;
      license = lib.licenses.gpl2;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ danbst ];
    };
}
