{ mkDerivation, lib, fetchFromGitHub, buildEnv, makeDesktopItem, runCommand, writeText, pkg-config
, cmake, qmake, cacert, jsoncpp, libX11, libXScrnSaver, lua, openssl, poco
, qtbase, qtwebengine, qtx11extras, sqlite }:

let
  name = "toggldesktop-${version}";
  version = "7.4.231";

  src = fetchFromGitHub {
    owner = "toggl";
    repo = "toggldesktop";
    rev = "v${version}";
    sha256 = "sha256-YaeeUlwz42i1ik5nUKSIy0IBrvu1moi95dBK2lKfGAY=";
  };

  bugsnag-qt = mkDerivation rec {
    pname = "bugsnag-qt";
    version = "20180522.005732";

    src = fetchFromGitHub {
      owner = "alpakido";
      repo = "bugsnag-qt";
      rev = version;
      sha256 = "sha256-2L7pxdQOniwrp1Kgq3Q8BFbjb2yGtGoKUiQC+B6tRgs=";
    };

    nativeBuildInputs = [ qmake ];
    buildInputs = [ qtbase ];
  };

  qxtglobalshortcut = mkDerivation rec {
    pname = "qxtglobalshortcut";
    version = "f584471dada2099ba06c574bdfdd8b078c2e3550";

    src = fetchFromGitHub {
      owner = "hluk";
      repo = "qxtglobalshortcut";
      rev = version;
      sha256 = "sha256-gb94rqK8j1mbD4YSXdOaxCdczZJFC6MU+iBsdf07wcc=";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ qtbase qtx11extras ];
  };

  qt-oauth-lib = mkDerivation rec {
    pname = "qt-oauth-lib";
    version = "20190125.190943";

    src = fetchFromGitHub {
      owner = "alpakido";
      repo = "qt-oauth-lib";
      rev = version;
      sha256 = "sha256-MjtNAN4F9JJFxM8MYpCv8tPe26RHtbXdq+lY49p+rn4=";
    };

    nativeBuildInputs = [ qmake ];
    buildInputs = [ qtbase qtwebengine ];
  };

  poco-pc = writeText "poco.pc" ''
    Name: Poco
    Description: ${poco.meta.description}
    Version: ${poco.version}
    Libs: -L${poco}/lib -lPocoDataSQLite -lPocoData -lPocoNet -lPocoNetSSL -lPocoCrypto -lPocoUtil -lPocoXML -lPocoFoundation
    Cflags: -I${poco}/include/Poco
  '';

  poco-pc-wrapped = runCommand "poco-pc-wrapped" {} ''
    mkdir -p $out/lib/pkgconfig && ln -s ${poco-pc} $_/poco.pc
  '';

  libtoggl = mkDerivation {
    name = "libtoggl-${version}";
    inherit src version;

    sourceRoot = "source/src";

    nativeBuildInputs = [ qmake pkg-config ];
    buildInputs = [ jsoncpp lua openssl poco poco-pc-wrapped sqlite libX11 ];

    postPatch = ''
      cat ${./libtoggl.pro} > libtoggl.pro
      rm get_focused_window_{mac,windows}.cc
    '';
  };

  toggldesktop = mkDerivation {
    name = "${name}-unwrapped";
    inherit src version;

    sourceRoot = "source/src/ui/linux/TogglDesktop";

    postPatch = ''
      substituteAll ${./TogglDesktop.pro} TogglDesktop.pro
      substituteInPlace toggl.cpp \
        --replace ./../../../toggl_api.h toggl_api.h
    '';

    postInstall = ''
      ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/cacert.pem
    '';

    nativeBuildInputs = [ qmake pkg-config ];

    buildInputs = [
      bugsnag-qt
      libtoggl
      qxtglobalshortcut
      qtbase
      qtwebengine
      qt-oauth-lib
      qtx11extras
      libX11
      libXScrnSaver
    ];
  };

  toggldesktop-icons = mkDerivation {
    name = "${name}-icons";
    inherit (toggldesktop) src sourceRoot;

    installPhase = ''
      for f in icons/*; do
        mkdir -p $out/share/icons/hicolor/$(basename $f)/apps
        mv $f/toggldesktop.png $_
      done
    '';
  };

  toggldesktop-wrapped = runCommand "toggldesktop-wrapped" {} ''
    mkdir -p $out/bin && ln -s ${toggldesktop}/toggldesktop $_
  '';

  desktopItem = makeDesktopItem rec {
    categories = [ "Utility" ];
    desktopName = "Toggl";
    genericName = desktopName;
    name = "toggldesktop";
    exec = "${toggldesktop-wrapped}/bin/toggldesktop";
    icon = "toggldesktop";
  };
in

buildEnv {
  inherit name;
  paths = [ desktopItem toggldesktop-icons toggldesktop-wrapped ];

  meta = with lib; {
    broken = true; # libtoggl is broken
    description = "Client for Toggl time tracking service";
    homepage = "https://github.com/toggl/toggldesktop";
    license = licenses.bsd3;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.linux;
  };
}
