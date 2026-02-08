{
  appimageTools,
  fetchurl,
  webkitgtk_4_1,
  lib,
  makeWrapper,
}:
let
  pname = "qidi-studio";
  version = "2.04.01.11";

  src = fetchurl {
    url = "https://github.com/QIDITECH/QIDIStudio/releases/download/v${version}/QIDIStudio_v0${version}_Ubuntu24.AppImage";
    hash = "sha256-+Uj0S4BOASST+3MqcFNdW1dBQeMxNC5btMUiNVxFs3g=";
  };

  appimageContents = appimageTools.extract {
    inherit version pname src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = pkgs: [
    webkitgtk_4_1
  ];

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/QIDIStudio.desktop $out/share/applications/QIDIStudio.desktop
    install -m 444 -D ${appimageContents}/QIDIStudio.png \
      $out/share/icons/hicolor/scalable/apps/QIDIStudio.png
    substituteInPlace $out/share/applications/QIDIStudio.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=qidi-studio'
    wrapProgram "$out/bin/qidi-studio" \
      --set-default WEBKIT_DISABLE_COMPOSITING_MODE 0 \
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER 0
  '';

  meta = {
    description = "Slicer for QIDI 3D Printers, based on Bambu Studio";
    longDescription = ''
      QIDI Studio is a professional 3D printer slicing software, which is perfectly compatible with all printers and 3D printing filaments of QIDI Technology.
      Multi-platform support, simple inerface, easy to use, complate functions, easy to learn 3D printing.
    '';
    homepage = "https://github.com/QIDITECH/QIDIStudio";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ niklasthorild ];
    mainProgram = "qidi-studio";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
