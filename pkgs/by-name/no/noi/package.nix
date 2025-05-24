{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "noi";
  version = "0.4.0";
  src = fetchurl {
    url = "https://github.com/lencx/Noi/releases/download/v${version}/Noi_linux_${version}.Appimage";
    hash = "sha256-ZwI1MpEoQn48zaan/GB7St6b15jtPHjwoUfD6bPkA3A=";
  };

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -m 644 -D ${contents}/Noi.desktop -t $out/share/applications
      echo "Icon=noi" >> $out/share/applications/Noi.desktop

      install -m 644 -D ${contents}/usr/lib/noi/resources/icons/icon.png $out/share/icons/hicolor/512x512/apps/noi.png
    '';

  meta = {
    description = "AI-enhanced, customizable browser designed to streamline your digital experience";
    homepage = "https://noi.nofwl.com";
    maintainers = with lib.maintainers; [ culxttes ];
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "noi";
  };
}
