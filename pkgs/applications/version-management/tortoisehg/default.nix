{ lib, fetchurl, python3Packages
, mercurial, qt5
}@args:
let
  tortoisehgSrc = fetchurl rec {
    meta.name = "tortoisehg-${meta.version}";
    meta.version = "5.2.1";
    url = "https://bitbucket.org/tortoisehg/thg/get/14221e991a5b623e0072d3bd340b759dbe9072ca.tar.gz";
    sha256 = "01rpzf5z99izcdda1ps9bhqvhw6qghagd8c1y7x19rv223zi05dv";
  };

  tortoiseMercurial = mercurial.overridePythonAttrs (old: rec {
    inherit (tortoisehgSrc.meta) version;
    src = fetchurl {
      url = "https://mercurial-scm.org/release/mercurial-${version}.tar.gz";
      sha256 = "1pxkd37b0a1mi2zakk1hi122lgz1ffy2fxdnbs8acwlqpw55bc8q";
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
      homepage = https://tortoisehg.bitbucket.io/;
      license = lib.licenses.gpl2;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ danbst ];
    };
}
