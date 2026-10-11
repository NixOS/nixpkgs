{
  appimageTools,
  fetchurl,
  lib,
}:

let
  pname = "henkan";
  version = "1.6.1";
  src = fetchurl {
    url = "https://github.com/kaanreal/henkan/releases/download/v${version}/Henkan-v${version}-linux.AppImage";
    hash = "sha256-T3zOuSM8daRFW3I/kVIDRuGHo02AP+Fn9axWrNi54cQ=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/usr/share/applications/Henkan.desktop \
      $out/share/applications/henkan.desktop
    substituteInPlace $out/share/applications/henkan.desktop \
      --replace-fail "Exec=henkan" "Exec=$out/bin/henkan"

    for icon in ${appimageContents}/usr/share/icons/hicolor/*/apps/henkan.png; do
      destination="''${icon#${appimageContents}/}"
      install -Dm644 "$icon" "$out/$destination"
    done
  '';

  meta = {
    description = "osu!mania to Etterna and StepMania converter";
    homepage = "https://henkan.kaanreal.me/";
    downloadPage = "https://github.com/kaanreal/henkan/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "henkan";
    maintainers = with lib.maintainers; [ kaanreal ];
  };
}
