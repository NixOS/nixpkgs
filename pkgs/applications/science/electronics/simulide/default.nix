{
  lib,
  fetchbzr,
  mkDerivation,
  qmake,
  qtserialport,
  qtmultimedia,
  qttools,
  qtscript,
}:

let
  generic =
    {
      version,
      release,
      rev,
      src,
      extraPostPatch ? "",
      extraBuildInputs ? [ ],
      iconPath ? "resources/icons/simulide.png",
      installFiles ? ''
        cp -r data examples $out/share/simulide
        cp simulide $out/bin/simulide
      '',
    }:
    mkDerivation {
      pname = "simulide";
      version = "${version}-${release}";
      inherit src;

      postPatch = ''
        sed -i resources/simulide.desktop \
          -e "s|^Exec=.*$|Exec=simulide|" \
          -e "s|^Icon=.*$|Icon=simulide|"

        # Note: older versions don't have REV_NO
        sed -i SimulIDE.pro \
          -e "s|^VERSION = .*$|VERSION = ${version}|" \
          -e "s|^RELEASE = .*$|RELEASE = -${release}|" \
          -e "s|^REV_NO = .*$|REV_NO = ${rev}|" \
          -e "s|^BUILD_DATE = .*$|BUILD_DATE = ??-??-??|"

        ${extraPostPatch}
      '';

      preConfigure = ''
        cd build_XX
      '';

      nativeBuildInputs = [ qmake ];

      buildInputs = [
        qtserialport
        qtmultimedia
        qttools
      ] ++ extraBuildInputs;

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
    };
in
{
  simulide_0_4_15 = generic rec {
    version = "0.4.15";
    release = "SR10";
    rev = "291";
    src = fetchbzr {
      # the branch name does not mach the version for some reason
      url = "https://code.launchpad.net/~arcachofo/simulide/simulide_0.4.14";
      sha256 = "sha256-BBoZr/S2pif0Jft5wrem8y00dXl08jq3kFiIUtOr3LM=";
      inherit rev;
    };
    extraPostPatch = ''
      # GCC 13 needs the <cstdint> header explicitly included
      sed -i src/gpsim/value.h -e '1i #include <cstdint>'
      sed -i src/gpsim/modules/watchdog.h -e '1i #include <cstdint>'
    '';
    extraBuildInputs = [ qtscript ];
    iconPath = "resources/icons/hicolor/256x256/simulide.png"; # upstream had a messed up icon path in this release
    installFiles = ''
      cp -r share/simulide/* $out/share/simulide
      cp bin/simulide $out/bin/simulide
    '';
  };

  simulide_1_0_0 = generic rec {
    version = "1.0.0";
    release = "SR2";
    rev = "1449";
    src = fetchbzr {
      url = "https://code.launchpad.net/~arcachofo/simulide/1.0.0";
      sha256 = "sha256-rJWZvnjVzaKXU2ktbde1w8LSNvu0jWkDIk4dq2l7t5g=";
      inherit rev;
    };
    extraBuildInputs = [ qtscript ];
  };

  simulide_1_1_0 = generic rec {
    version = "1.1.0";
    release = "SR0";
    rev = "1917";
    src = fetchbzr {
      url = "https://code.launchpad.net/~arcachofo/simulide/1.1.0";
      sha256 = "sha256-qNBaGWl89Le9uC1VFK+xYhrLzIvOIWjkQbutnrAmZ2M=";
      inherit rev;
    };
  };
}
