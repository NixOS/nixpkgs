{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
}:
appimageTools.wrapAppImage (finalAttrs: {
  pname = "bazecor";
  version = "1.11.0";

  src = fetchurl {
    url = "https://github.com/Dygmalab/Bazecor/releases/download/v${finalAttrs.version}/Bazecor-${finalAttrs.version}-x64.AppImage";
    hash = "sha256-8mTTEiKhBdqyDMKJn25XM6Q0ITEa6/P2fmFvl2L2scM=";
  };

  contents = appimageTools.extract {
    inherit (finalAttrs) pname version src;

    # Workaround for https://github.com/Dygmalab/Bazecor/issues/370
    postExtract = ''
      substituteInPlace \
        $out/usr/lib/bazecor/resources/app/.webpack/main/index.js \
        --replace-fail \
          't.checkUdev=()=>{try{for(const e of m){const t=h.default.join(e,p);if(l.default.existsSync(t)&&l.default.readFileSync(t,"utf-8").trim()===f.trim())return!0}}catch(e){d.default.error(e)}return!1}' \
          't.checkUdev=()=>{return!0}'
    '';
  };

  # also make sure to update the udev rules in ./60-dygma.rules; most recently
  # taken from
  # https://github.com/Dygmalab/Bazecor/blob/v1.4.4/src/main/utils/udev.ts#L6

  nativeBuildInputs = [ makeWrapper ];

  extraPkgs = pkgs: [ pkgs.glib ];

  # Also expose the udev rules here, so it can be used as:
  #   services.udev.packages = [ pkgs.bazecor ];
  # to allow non-root modifications to the keyboards.

  extraInstallCommands = ''
    wrapProgram $out/bin/bazecor \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -m 444 -D ${finalAttrs.contents}/Bazecor.desktop -t $out/share/applications
    install -m 444 -D ${finalAttrs.contents}/bazecor.png -t $out/share/icons/hicolor/512x512/apps

    mkdir -p $out/lib/udev/rules.d
    install -m 444 -D ${./60-dygma.rules} $out/lib/udev/rules.d/60-dygma.rules

    substituteInPlace $out/share/applications/Bazecor.desktop \
      --replace-fail 'Exec=Bazecor' 'Exec=bazecor'
  '';

  meta = {
    description = "Graphical configurator for Dygma Products";
    homepage = "https://github.com/Dygmalab/Bazecor";
    changelog = "https://github.com/Dygmalab/Bazecor/releases/tag/v${finalAttrs.version}";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      gcleroux
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "bazecor";
  };
})
