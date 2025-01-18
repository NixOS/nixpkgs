{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
}:
let
  pname = "bazecor";
  version = "1.4.4";
  src = appimageTools.extract {
    inherit pname version;
    src = fetchurl {
      url = "https://github.com/Dygmalab/Bazecor/releases/download/v${version}/Bazecor-${version}-x64.AppImage";
      hash = "sha256-ep+3lqWdktyvbTKxfLcPiVq9/5f0xBHwKG1+BxDDBQA=";
    };

    # Workaround for https://github.com/Dygmalab/Bazecor/issues/370
    postExtract = ''
      substituteInPlace \
        $out/usr/lib/bazecor/resources/app/.webpack/main/index.js \
        --replace-fail \
          'checkUdev=()=>{try{if(c.default.existsSync(f))return c.default.readFileSync(f,"utf-8").trim()===d.trim()}catch(e){u.default.error(e)}return!1}' \
          'checkUdev=()=>{return 1}'
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version src;

  # also make sure to update the udev rules in ./60-dygma.rules; most recently
  # taken from
  # https://github.com/Dygmalab/Bazecor/blob/v1.4.4/src/main/utils/udev.ts#L6

  extraPkgs = pkgs: [ pkgs.glib ];

  # Also expose the udev rules here, so it can be used as:
  #   services.udev.packages = [ pkgs.bazecor ];
  # to allow non-root modifications to the keyboards.

  extraInstallCommands = ''
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/bazecor \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    install -m 444 -D ${src}/Bazecor.desktop -t $out/share/applications
    install -m 444 -D ${src}/bazecor.png -t $out/share/pixmaps

    mkdir -p $out/lib/udev/rules.d
    install -m 444 -D ${./60-dygma.rules} $out/lib/udev/rules.d/60-dygma.rules

    substituteInPlace $out/share/applications/Bazecor.desktop \
      --replace-fail 'Exec=Bazecor' 'Exec=bazecor'
  '';

  meta = {
    description = "Graphical configurator for Dygma Products";
    homepage = "https://github.com/Dygmalab/Bazecor";
    changelog = "https://github.com/Dygmalab/Bazecor/releases/tag/v${version}";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      amesgen
      gcleroux
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "bazecor";
  };
}
