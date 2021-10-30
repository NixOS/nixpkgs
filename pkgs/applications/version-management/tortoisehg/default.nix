{ lib, fetchurl, python3Packages
, mercurial, qt5
}:

python3Packages.buildPythonApplication rec {
    pname = "tortoisehg";
    version = "5.9";

    src = fetchurl {
      url = "https://www.mercurial-scm.org/release/tortoisehg/targz/tortoisehg-${version}.tar.gz";
      sha256 = "1y8nb2b9j9qx11k1wrb9hydc94dgbsqx4yf2bv8y878hqmk1z57a";
    };

    # Extension point for when thg's mercurial is lagging behind mainline.
    tortoiseMercurial = mercurial;

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
      license = lib.licenses.gpl2Only;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ danbst ];
    };
}
