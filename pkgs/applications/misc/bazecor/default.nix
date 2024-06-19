{ lib
, appimageTools
, fetchurl
}:

appimageTools.wrapAppImage rec {
  pname = "bazecor";
  version = "1.3.11";

  src = appimageTools.extract {
    inherit pname version;
    src = fetchurl {
      url = "https://github.com/Dygmalab/Bazecor/releases/download/v${version}/Bazecor-${version}-x64.AppImage";
      hash = "sha256-iMurQDF0CBMnJnjmEgNIKYd8C5B4FguMi4Jqa3dHr3o=";
    };

    # Workaround for https://github.com/Dygmalab/Bazecor/issues/370
    postExtract = ''
      substituteInPlace \
        $out/usr/lib/bazecor/resources/app/.webpack/main/index.js \
        --replace \
          'checkUdev=()=>{try{if(c.default.existsSync(f))return c.default.readFileSync(f,"utf-8").trim()===l.trim()}catch(e){console.error(e)}return!1}' \
          'checkUdev=()=>{return 1}'
    '';
  };

  # also make sure to update the udev rules in ./10-dygma.rules; most recently
  # taken from
  # https://github.com/Dygmalab/Bazecor/blob/v1.3.11/src/main/utils/udev.ts#L6

  extraPkgs = pkgs: [ pkgs.glib ];

  # Also expose the udev rules here, so it can be used as:
  #   services.udev.packages = [ pkgs.bazecor ];
  # to allow non-root modifications to the keyboards.

  extraInstallCommands = ''
    install -m 444 -D ${src}/Bazecor.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/Bazecor.desktop \
      --replace 'Exec=Bazecor' 'Exec=bazecor'

    install -m 444 -D ${src}/bazecor.png -t $out/share/pixmaps

    mkdir -p $out/lib/udev/rules.d
    ln -s --target-directory=$out/lib/udev/rules.d ${./10-dygma.rules}
  '';

  meta = {
    description = "Graphical configurator for Dygma Products";
    homepage = "https://github.com/Dygmalab/Bazecor";
    changelog = "https://github.com/Dygmalab/Bazecor/releases/tag/v${version}";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ amesgen ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "bazecor";
  };
}
