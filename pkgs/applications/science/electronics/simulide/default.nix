{ lib
, fetchbzr
, mkDerivation
, qmake
, qtserialport
, qtmultimedia
, qttools
, qtscript
}:

let
  version = "0.4.15";
  release = "SR10";
  branch = "simulide_0.4.14"; # the branch name does not mach the version for some reason
  rev = "291";
  sha256 = "sha256-BBoZr/S2pif0Jft5wrem8y00dXl08jq3kFiIUtOr3LM=";
in
mkDerivation {
  pname = "simulide";
  version = "${version}-${release}";

  src = fetchbzr {
    url = "https://code.launchpad.net/~arcachofo/simulide/${branch}";
    inherit rev sha256;
  };

  postPatch = ''
    # GCC 13 needs this header explicitly included
    sed -i src/gpsim/value.h -e '1i #include <cstdint>'
    sed -i src/gpsim/modules/watchdog.h -e '1i #include <cstdint>'

    sed -i resources/simulide.desktop \
      -e "s|^Exec=.*$|Exec=simulide|" \
      -e "s|^Icon=.*$|Icon=simulide|"
    sed -i SimulIDE.pro \
      -e "s|^VERSION = .*$|VERSION = ${version}|" \
      -e "s|^RELEASE = .*$|RELEASE = -${release}|" \
      -e "s|^REV_NO = .*$|REV_NO = ${rev}|" \
      -e "s|^BUILD_DATE = .*$|BUILD_DATE = ??-??-??|"
  '';

  preConfigure = ''
    cd build_XX
  '';

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtserialport
    qtmultimedia
    qttools
    qtscript
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ../resources/simulide.desktop $out/share/applications/simulide.desktop
    install -Dm644 ../resources/icons/hicolor/256x256/simulide.png $out/share/icons/hicolor/256x256/apps/simulide.png

    mkdir -p $out/share/simulide $out/bin

    pushd executables/SimulIDE_*
    cp -r share/simulide/* $out/share/simulide
    cp bin/simulide $out/bin/simulide
    popd

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple real time electronic circuit simulator";
    longDescription = ''
      SimulIDE is a simple real time electronic circuit simulator, intended for hobbyist or students
      to learn and experiment with analog and digital electronic circuits and microcontrollers.
      It supports PIC, AVR, Arduino and other MCUs and MPUs.
    '';
    homepage = "https://simulide.com/";
    license = licenses.gpl3Only;
    mainProgram = "simulide";
    maintainers = with maintainers; [ carloscraveiro tomasajt ];
    platforms = ["x86_64-linux"];
  };
}
