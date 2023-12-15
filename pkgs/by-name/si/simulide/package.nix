{ lib
, gccStdenv # Darwin also needs gcc
, fetchbzr
, substituteAll
, libsForQt5
, old ? false
}:

let
  versionTable = {
    old = {
      version = "0.4.15";
      release = "SR10";
      branch = "simulide_0.4.14"; # the branch name does not mach the version for some reason
      rev = "291";
      sha256 = "sha256-BBoZr/S2pif0Jft5wrem8y00dXl08jq3kFiIUtOr3LM=";
    };
    new = {
      version = "1.1.0";
      release = "RC0";
      branch = "1.1.0";
      rev = "1909";
      sha256 = "sha256-AvucduVraSlTXT8Hnpgh9i5Tsxji++vgjAJX1ZFnMs4=";
    };
  };
  versionInfo = if old then versionTable.old else versionTable.new;
in

gccStdenv.mkDerivation {
  pname = "simulide";
  version = "${versionInfo.version}-${versionInfo.release}";

  src = fetchbzr {
    url = "https://code.launchpad.net/~arcachofo/simulide/${versionInfo.branch}";
    inherit (versionInfo) rev sha256;
  };

  postPatch = ''
    sed -i resources/simulide.desktop \
      -e "s|^Exec=.*$|Exec=simulide|" \
      -e "s|^Icon=.*$|Icon=simulide|"

    sed -i SimulIDE.pro \
      -e "s|^VERSION = .*$|VERSION = ${versionInfo.version}|" \
      -e "s|^RELEASE = .*$|RELEASE = -${versionInfo.release}|" \
      -e "s|^REV_NO = .*$|REV_NO = ${versionInfo.rev}|" \
      -e "s|^BUILD_DATE = .*$|BUILD_DATE = ??-??-??|"

    # Force darwin to use gcc
    sed -i SimulIDE.pro \
      -e "s|QMAKE_CC = .*$|QMAKE_CC = ${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}gcc|" \
      -e "s|QMAKE_CXX = .*$|QMAKE_CXX = ${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}g++|" \
      -e "s|QMAKE_LINK = .*$|QMAKE_LINK = ${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}g++|"

    export CC=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}gcc \
           CXX=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}g++ \
           LINK=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}g++ \
           CPP=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}cpp \
           CXXCPP=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}cpp \
           LD=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}ld

    $CC || true
    $CXX || true
    $LINK || true
    $CPP || true
    $LD || true

    cat SimulIDE.pro
  '';

  makeFlags = [
    "CC=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}gcc"
    "CXX=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}g++"
    "LINK=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}g++"
    "CPP=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}cpp"
    "CXXCPP=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}cpp"
    "LD=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}ld"
  ];

  preConfigure = ''
    cd build_XX
    export
  '';

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtserialport
    libsForQt5.qtmultimedia
    libsForQt5.qttools
  ] ++ lib.optional old libsForQt5.qtscript;

  installPhase = ''
    runHook preInstall

    install -Dm644 ../resources/simulide.desktop $out/share/applications/simulide.desktop
    install -Dm644 ../resources/icons/hicolor/256x256/simulide.png $out/share/icons/hicolor/256x256/apps/simulide.png

    pushd executables/SimulIDE_*
    dir -R .

    ${lib.optionalString gccStdenv.isLinux ''
      mkdir -p $out/share/simulide $out/bin
      ${lib.optionalString old ''
        cp -r share/simulide/* $out/share/simulide
        cp bin/simulide $out/bin/simulide
      ''}
      ${lib.optionalString (!old) ''
        cp -r * $out/share/simulide
        mv $out/share/simulide/simulide $out/bin/simulide
      ''}
    ''}
    ${lib.optionalString gccStdenv.isDarwin ''
      mkdir -p $out/Applications $out/bin
      cp -r simulide.app $out/Applications/simulide.app
      ln -s $out/Applications/simulide.app/Contents/MacOs/simulide $out/bin/simulide
    ''}

    dir -R $out
    popd

    runHook postInstall
  '';

  meta = {
    description = "A simple real time electronic circuit simulator";
    longDescription = ''
      SimulIDE is a simple real time electronic circuit simulator, intended for hobbyist or students
      to learn and experiment with analog and digital electronic circuits and microcontrollers.
      It supports PIC, AVR, Arduino and other MCUs and MPUs.
    '';
    homepage = "https://simulide.com/";
    license = lib.licenses.gpl3Only;
    mainProgram = "simulide";
    maintainers = with lib.maintainers; [ /* carloscraveiro */ tomasajt ];
    platforms = lib.platforms.unix;
  };
}
