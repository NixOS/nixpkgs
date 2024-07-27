{
  lib,
  pkgs,
  stdenv,
  fetchurl,
  buildFHSEnv,
  bash,
  writeText,
  makeDesktopItem,
  copyDesktopItems,
  writeScriptBin,
  runtimeShell,
  autoPatchelfHook
}:

let
  eparakstitajs = (
    stdenv.mkDerivation rec {
      pname = "eparakstitajs3";
      version = "1.7.1";

      src = fetchurl {
        url = "https://www.eparaksts.lv/files/ep3updates/eparakstitajs3-${version}_amd64.tar.gz";
        sha256 = "sha256-OdoJqZvw3umqEpvzbKN2qmF4Mq0XSC7AIu8DlJ061L4=";
      };

      nativeBuildInputs = [
        copyDesktopItems
      ];

      desktopItems = [
        (makeDesktopItem {
          name = "eparakstitajs3";
          desktopName = "eParakstītājs 3.0";
          exec = "eparakstitajs3";
          icon = "eparakstitajs3";
          comment = "LVRTC signed document authoring tool";
          categories = [
            "Application"
            "Viewer"
          ];
          mimeTypes = [
            "application/pdf"
            "application/lv.eme.edoc"
            "application/vnd.etsi.asic-e+zip"
          ];
        })
      ];

      fakeDPKG = writeScriptBin "dpkg" ''
        #!${runtimeShell}

        # A dpkg shim
        # This app has hardcoded calls for version checks

        usage() {
            echo 'dpkg -s <pkg-name>'
            exit 1
        }

        if [ -z "$1" ] || [ "$1" != "-s" ] || [ -z "$2" ]; then usage; fi

        if [ "$2" = "latvia-eid-middleware" ]; then
          echo "Package: latvia-eid-middleware"
          echo "Version: ${pkgs.latvia-eid-middleware.version}"
          echo "Status: install ok installed"
          exit 0
        fi

        exit 1
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r ./ $out

        mkdir -p $out/lib/app/lib/native/linux64
        cp -r ./lib/native/linux64/* $out/lib/app/lib/native/linux64/

        mkdir -p $out/bin/special
        ln -s ${fakeDPKG}/bin/dpkg $out/bin/special/dpkg

        runHook postInstall
      '';
    }
  );
in
buildFHSEnv rec {
  name = "eparakstitajs3";

  targetPkgs = pkgs: with pkgs; [
    alsa-lib
    glib
    gtk2
    gtk2-x11
    gtk3
    gtk3-x11
    latvia-eid-middleware
    opensc
    pango
    pcscliteWithPolkit
    xdg-utils
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    zlib
  ];

  runScript = "${bash}/bin/bash ${
    writeText "eparakstitajs3-wrapper"
    ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${eparakstitajs}/lib/native/linux64
    export PATH=$PATH:${eparakstitajs}/bin/special
    ${eparakstitajs}/bin/eparakstitajs3
    ''
  }";

  meta = with lib; {
    description = "Application software to sign and validate documents in EDOC and PDF formats.";
    homepage = "https://www.eparaksts.lv/";
    license = licenses.unfree;
    maintainers = with maintainers; [ vilsol ];
    platforms = platforms.linux;
  };
}
