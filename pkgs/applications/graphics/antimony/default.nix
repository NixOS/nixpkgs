{ lib, stdenv, fetchFromGitHub, libpng, python3
, libGLU, libGL, qtbase, wrapQtAppsHook, ncurses
, cmake, flex, lemon
, makeDesktopItem, copyDesktopItems
}:

let
  gitRev    = "8fb4b0929ce84cf375bfb83a9d522ccd80681eaf";
  gitBranch = "develop";
  gitTag    = "0.9.3";
in
  stdenv.mkDerivation {
    pname = "antimony";
    version = "2020-03-28";

    src = fetchFromGitHub {
      owner  = "mkeeter";
      repo   = "antimony";
      rev    = gitRev;
      sha256 = "1s0zmq5jmhmb1wcsyaxfmii448g6x8b41mzvb1awlljj85qj0k2s";
    };

    patches = [ ./paths-fix.patch ];

    postPatch = ''
       sed -i "s,/usr/local,$out,g" \
       app/CMakeLists.txt app/app/app.cpp app/app/main.cpp
       sed -i "s,python3,${python3.executable}," CMakeLists.txt
    '';

    postInstall = lib.optionalString stdenv.isLinux ''
      install -Dm644 $src/deploy/icon.svg $out/share/icons/hicolor/scalable/apps/antimony.svg
      install -Dm644 ${./mimetype.xml} $out/share/mime/packages/antimony.xml
    '';

    buildInputs = [
      libpng python3 python3.pkgs.boost
      libGLU libGL qtbase ncurses
    ];

    nativeBuildInputs = [ cmake flex lemon wrapQtAppsHook copyDesktopItems ];

    desktopItems = [
      (makeDesktopItem {
        name = "antimony";
        desktopName = "Antimony";
        comment="Tree-based Modeler";
        genericName = "CAD Application";
        exec = "antimony %f";
        icon = "antimony";
        terminal = "false";
        categories = "Graphics;Science;Engineering";
        mimeType = "application/x-extension-sb;application/x-antimony;";
        extraEntries = ''
          StartupWMClass=antimony
          Version=1.0
        '';
      })
    ];

    cmakeFlags= [
      "-DGITREV=${gitRev}"
      "-DGITTAG=${gitTag}"
      "-DGITBRANCH=${gitBranch}"
    ];

    meta = with lib; {
      description = "A computer-aided design (CAD) tool from a parallel universe";
      homepage    = "https://github.com/mkeeter/antimony";
      license     = licenses.mit;
      maintainers = with maintainers; [ rnhmjoj ];
      platforms   = platforms.linux;
    };
  }
