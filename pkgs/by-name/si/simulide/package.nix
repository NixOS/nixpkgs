{
  lib,
  stdenv,
  fetchbzr,
  libsForQt5,
  versionNum ? "1.0.0",
}:

let
  versionInfo = {
    "0.4.15" = rec {
      release = "SR10";
      rev = "291";
      src = fetchbzr {
        # the branch name does not mach the version for some reason
        url = "https://code.launchpad.net/~arcachofo/simulide/simulide_0.4.14";
        sha256 = "sha256-BBoZr/S2pif0Jft5wrem8y00dXl08jq3kFiIUtOr3LM=";
        inherit rev;
      };
    };
    "1.0.0" = rec {
      release = "SR2";
      rev = "1449";
      src = fetchbzr {
        url = "https://code.launchpad.net/~arcachofo/simulide/1.0.0";
        sha256 = "sha256-rJWZvnjVzaKXU2ktbde1w8LSNvu0jWkDIk4dq2l7t5g=";
        inherit rev;
      };
    };
    "1.1.0" = rec {
      release = "SR0";
      rev = "1917";
      src = fetchbzr {
        url = "https://code.launchpad.net/~arcachofo/simulide/1.1.0";
        sha256 = "sha256-qNBaGWl89Le9uC1VFK+xYhrLzIvOIWjkQbutnrAmZ2M=";
        inherit rev;
      };
    };
  };
in

let
  inherit (versionInfo.${versionNum} or (throw "Unsupported versionNum")) release rev src;

  extraPostPatch = lib.optionalString (lib.versionOlder versionNum "1.0.0") ''
    # GCC 13 needs the <cstdint> header explicitly included
    sed -i src/gpsim/value.h -e '1i #include <cstdint>'
    sed -i src/gpsim/modules/watchdog.h -e '1i #include <cstdint>'
  '';

  extraBuildInputs = lib.optionals (lib.versionOlder versionNum "1.1.0") [
    libsForQt5.qtscript
  ];

  iconPath =
    if lib.versionOlder versionNum "1.0.0" then
      "resources/icons/hicolor/256x256/simulide.png" # upstream had a messed up icon path in this release
    else
      "resources/icons/simulide.png";

  installFiles =
    if lib.versionOlder versionNum "1.0.0" then
      ''
        cp -r share/simulide/* $out/share/simulide
        cp bin/simulide $out/bin/simulide
      ''
    else
      ''
        cp -r data examples $out/share/simulide
        cp simulide $out/bin/simulide
      '';

in

stdenv.mkDerivation {
  pname = "simulide";
  version = "${versionNum}-${release}";
  inherit src;

  postPatch = ''
    sed -i resources/simulide.desktop \
      -e "s|^Exec=.*$|Exec=simulide|" \
      -e "s|^Icon=.*$|Icon=simulide|"

    # Note: older versions don't have REV_NO
    sed -i SimulIDE.pro \
      -e "s|^VERSION = .*$|VERSION = ${versionNum}|" \
      -e "s|^RELEASE = .*$|RELEASE = -${release}|" \
      -e "s|^REV_NO = .*$|REV_NO = ${rev}|" \
      -e "s|^BUILD_DATE = .*$|BUILD_DATE = ??-??-??|"

    ${extraPostPatch}
  '';

  preConfigure = ''
    cd build_XX
  '';

  nativeBuildInputs = with libsForQt5; [
    qmake
    wrapQtAppsHook
  ];

  buildInputs =
    (with libsForQt5; [
      qtserialport
      qtmultimedia
      qttools
    ])
    ++ extraBuildInputs;

  installPhase = ''
    runHook preInstall

    install -Dm644 ../resources/simulide.desktop $out/share/applications/simulide.desktop
    install -Dm644 ../${iconPath} $out/share/icons/hicolor/256x256/apps/simulide.png

    mkdir -p $out/share/simulide $out/bin
    pushd executables/SimulIDE_*
    ${installFiles}
    popd

    runHook postInstall
  '';

  meta = {
    description = "Simple real time electronic circuit simulator";
    longDescription = ''
      SimulIDE is a simple real time electronic circuit simulator, intended for hobbyist or students
      to learn and experiment with analog and digital electronic circuits and microcontrollers.
      It supports PIC, AVR, Arduino and other MCUs and MPUs.
    '';
    homepage = "https://simulide.com/";
    license = lib.licenses.gpl3Only;
    mainProgram = "simulide";
    maintainers = with lib.maintainers; [
      carloscraveiro
      tomasajt
    ];
    platforms = [ "x86_64-linux" ];
  };
}
