{ fetchFromGitHub
, pkg-config
, stdenv
, lib
# Package dependencies
, qt5
, atools
, plasma5Packages
}:

let
  customMarble = plasma5Packages.marble.overrideAttrs (old: { src = fetchFromGitHub {
      owner = "albar965";
      repo = "marble";
      rev = "722acf7f8d79023f6c6a761063645a1470bb3935"; # MUST be lnm/1.1 branch
      sha256 = "sha256-5GSa+xIQS9EgJXxMFUOA5jTtHJ6Dl4C9yAkFPIOrgo8=";
    };
    preConfigure = ''
      cmakeFlags+=" -DQTONLY=TRUE -DBUILD_MARBLE_EXAMPLES=NO -DBUILD_INHIBIT_SCREENSAVER_PLUGIN=NO -DBUILD_MARBLE_APPS=NO -DBUILD_MARBLE_EXAMPLES=NO -DBUILD_MARBLE_TESTS=NO -DBUILD_MARBLE_TOOLS=NO -DBUILD_TESTING=NO -DBUILD_WITH_DBUS=NO -DMARBLE_EMPTY_MAPTHEME=YES -DMOBILE=NO -DWITH_DESIGNER_PLUGIN=NO -DWITH_Phonon=NO -DWITH_Qt5Location=NO -DWITH_Qt5Positioning=NO -DWITH_Qt5SerialPort=NO -DWITH_ZLIB=NO -DWITH_libgps=NO -DWITH_libshp=NO -DWITH_libwlocate=NO -Wno-deprecated-copy -Wno-deprecated -Wno-deprecated-declarations -DINCLUDE_INSTALL_DIR=''${!outputDev}/include"
    '';
  });
in
stdenv.mkDerivation rec {
  pname = "littlenavmap";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "albar965";
    repo = "littlenavmap";
    rev = "v${version}";
    sha256 = "sha256-u3H2U+8HZD18Yt6UB7QTTQOrrzN03PGolbFYddG8AIc=";
  };

  patches = [ ./littlenavmap.desktop.patch ];

  ATOOLS_LIB_PATH = atools;
  ATOOLS_INC_PATH = "${atools}/include/src";
  MARBLE_LIB_PATH = "${customMarble}/lib";
  MARBLE_INC_PATH = "${customMarble}/include";

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    qt5.qmake
    pkg-config
    qt5.qttools
  ];
  buildInputs = [
    qt5.qtwebengine
    atools
    customMarble
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p build
    cd build
    qmake ../littlenavmap.pro CONFIG+="release" QMAKE_CXXFLAGS+=' -Wno-deprecated-copy -Wno-deprecated -Wno-deprecated-declarations'
    make -j $(nproc)
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib/littlenavmap $out/share/{applications,icons/hicolor/{32x32,1024x1024,scalable}/apps}
    mv littlenavmap customize data help translations plugins $out/lib/littlenavmap/
    ln -s $out/lib/lressources/icons/littlenavmap.pngittlenavmap/littlenavmap $out/bin/

    cd ..
    mv resources/icons/littlenavmap.png $out/share/icons/hicolor/32x32/apps/littlenavmap.png
    mv resources/icons/littlenavmap1024.png $out/share/icons/hicolor/1024x1024/apps/littlenavmap.png
    mv resources/icons/littlenavmap.svg $out/share/icons/hicolor/scalable/apps/littlenavmap.svg
    mv desktop/Little\ Navmap.desktop $out/share/applications/littlenavmap.desktop
    runHook postinstall
  '';

  meta = with lib; {
    homepage = "https://albar965.github.io/index.html";
    description = "A free open source flight planner, navigation tool, moving map, airport search and airport information system";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nayala ];
  };
}
