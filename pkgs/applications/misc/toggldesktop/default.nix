{ stdenv, fetchzip, buildEnv, makeDesktopItem, runCommand, writeText, pkgconfig
, cmake, qmake, cacert, jsoncpp, libX11, libXScrnSaver, lua, openssl, poco
, qtbase, qtwebkit, qtx11extras, sqlite }:

let
  name = "toggldesktop-${version}";
  version = "7.4.231";

  src = fetchzip {
    url = "https://github.com/toggl/toggldesktop/archive/v${version}.tar.gz";
    sha256 = "01hqkx9dljnhwnyqi6mmzfp02hnbi2j50rsfiasniqrkbi99x9v1";
  };

  bugsnag-qt = stdenv.mkDerivation rec {
    name = "bugsnag-qt-${version}";
    version = "20180522.005732";

    src = fetchzip {
      url = "https://github.com/yegortimoshenko/bugsnag-qt/archive/${version}.tar.gz";
      sha256 = "02s6mlggh0i4a856md46dipy6mh47isap82jlwmjr7hfsk2ykgnq";
    };

    nativeBuildInputs = [ qmake ];
    buildInputs = [ qtbase ];
  };

  qxtglobalshortcut = stdenv.mkDerivation rec {
    name = "qxtglobalshortcut-${version}";
    version = "f584471dada2099ba06c574bdfdd8b078c2e3550";

    src = fetchzip {
      url = "https://github.com/hluk/qxtglobalshortcut/archive/${version}.tar.gz";
      sha256 = "1iy17gypav10z8aa62s5jb6mq9y4kb9ms4l61ydmk3xwlap7igw1";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ qtbase qtx11extras ];
  };

  qt-oauth-lib = stdenv.mkDerivation rec {
    name = "qt-oauth-lib-${version}";
    version = "20180521.233208";

    src = fetchzip {
      url = "https://github.com/yegortimoshenko/qt-oauth-lib/archive/${version}.tar.gz";
      sha256 = "0f46d44slzvzaqx0lksvv14lsc1jp8vd2mragxd61r820hybf5z3";
    };

    nativeBuildInputs = [ qmake ];
    buildInputs = [ qtbase qtwebkit ];
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

  libtoggl = stdenv.mkDerivation {
    name = "libtoggl-${version}";
    inherit src version;

    sourceRoot = "source/src";

    nativeBuildInputs = [ qmake pkgconfig ];
    buildInputs = [ jsoncpp lua openssl poco poco-pc-wrapped sqlite libX11 ];

    postPatch = ''
      cat ${./libtoggl.pro} > libtoggl.pro
      rm get_focused_window_{mac,windows}.cc
    '';
  };

  toggldesktop = stdenv.mkDerivation {
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

    nativeBuildInputs = [ qmake pkgconfig ];

    buildInputs = [
      bugsnag-qt
      libtoggl
      qxtglobalshortcut
      qtbase
      qtwebkit
      qt-oauth-lib
      qtx11extras
      libX11
      libXScrnSaver
    ];
  };

  toggldesktop-icons = stdenv.mkDerivation {
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
    categories = "Utility;";
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

  meta = with stdenv.lib; {
    description = "Client for Toggl time tracking service";
    homepage = https://github.com/toggl/toggldesktop;
    license = licenses.bsd3;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.linux;
  };
}
