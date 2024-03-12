{ lib, appimageTools, fetchurl, makeWrapper }:
let
  pname = "bazecor";
  version = "1.3.9";
  src = fetchurl {
    url = "https://github.com/Dygmalab/Bazecor/releases/download/v${version}/Bazecor-${version}-x64.AppImage";
    hash = "sha256-qve5xxhhyVej8dPDkZ7QQdeDUmqGO4pHJTykbS4RhAk=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;

    # Workaround for https://github.com/Dygmalab/Bazecor/issues/370
    postExtract = ''
      substituteInPlace \
        $out/usr/lib/${pname}/resources/app/.webpack/main/index.js \
        --replace \
          'checkUdev=()=>{try{if(c.default.existsSync(f))return c.default.readFileSync(f,"utf-8").trim()===l.trim()}catch(e){console.error(e)}return!1}' \
          'checkUdev=()=>{return 1}'
    '';
  };
in appimageTools.wrapType2 {
  inherit pname version src;

  # also make sure to update the udev rules in ./10-dygma.rules; most recently
  # taken from
  # https://github.com/Dygmalab/Bazecor/blob/v1.3.9/src/main/utils/udev.ts#L6

  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [ p.glib ];

  # Also expose the udev rules here, so it can be used as:
  #   services.udev.packages = [ pkgs.bazecor ];
  # to allow non-root modifications to the keyboards.

  extraInstallCommands = ''
    ln -s $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/Bazecor.desktop -t $out/share/applications
    install -m 444 -D ${appimageContents}/bazecor.png -t $out/share/pixmaps

    mkdir -p $out/lib/udev/rules.d
    ln -s ${./10-dygma.rules} $out/lib/udev/rules.d

    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram "$out/bin/${pname}" \
       --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}"

    substituteInPlace $out/share/applications/Bazecor.desktop \
      --replace 'Exec=Bazecor' 'Exec=${pname}'
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
