{ lib, fetchurl, python3Packages
, mercurial, qt5
}@args:
let
  tortoisehgSrc = fetchurl rec {
    meta.name = "tortoisehg-${meta.version}";
    meta.version = "5.6";
    url = "https://www.mercurial-scm.org/release/tortoisehg/targz/tortoisehg-${meta.version}.tar.gz";
    sha256 = "031bafj88wggpvw0lgvl0djhlbhs9nls9vzwvni8yn0m0bgzc9gr";
  };

  tortoiseMercurial = mercurial.overridePythonAttrs (old: rec {
    inherit (tortoisehgSrc.meta) version;
    src = fetchurl {
      url = "https://mercurial-scm.org/release/mercurial-${version}.tar.gz";
      sha256 = "1hk2y30zzdnlv8f71kabvh0xi9c7qhp28ksh20vpd0r712sv79yz";
    };
  });

in python3Packages.buildPythonApplication {
    inherit (tortoisehgSrc.meta) name version;
    src = tortoisehgSrc;

    propagatedBuildInputs = with python3Packages; [
      tortoiseMercurial qscintilla-qt5 iniparse
    ];
    nativeBuildInputs = [ qt5.wrapQtAppsHook ];

    doCheck = false; # tests fail with "thg: cannot connect to X server"
    postInstall = ''
      mkdir -p $out/share/doc/tortoisehg
      cp COPYING.txt $out/share/doc/tortoisehg/Copying.txt
      # convenient alias
      ln -s $out/bin/thg $out/bin/tortoisehg
      wrapQtApp $out/bin/thg
    '';

    checkPhase = ''
      echo "test: thg version"
      $out/bin/thg version
    '';

    passthru.mercurial = tortoiseMercurial;

    meta = {
      description = "Qt based graphical tool for working with Mercurial";
      homepage = "https://tortoisehg.bitbucket.io/";
      license = lib.licenses.gpl2;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ danbst ];
    };
}
