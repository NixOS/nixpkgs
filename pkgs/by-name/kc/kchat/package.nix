{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 rec {
  pname = "kchat";
  version = "2.4.0";

  src = fetchurl {
    url = "https://download.storage5.infomaniak.com/kchat/kchat-desktop-${version}-linux-x86_64.AppImage";
    name = "kchat-${version}.AppImage";
    hash = "sha256-8mkkHod7iBhHVAL/vQCVnmwVlPGikdHhtiEaFVIayrU=";
  };

  extraInstallCommands =
    let
      contents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      mkdir -p "$out/share/applications"
      mkdir -p "$out/share/lib/kchat"
      cp -r ${contents}/{locales,resources} "$out/share/lib/kchat"
      cp -r ${contents}/usr/* "$out"
      cp "${contents}/kchat-desktop.desktop" "$out/share/applications/"
      mv "$out/bin/kchat" "$out/bin/${meta.mainProgram}" || true
      substituteInPlace $out/share/applications/kchat-desktop.desktop --replace 'Exec=AppRun' 'Exec=${meta.mainProgram}'
    '';

  meta = with lib; {
    description = "Instant messaging service part of Infomaniak KSuite";
    homepage = "https://www.infomaniak.com/en/apps/download-kchat";
    license = licenses.unfree;
    maintainers = [ maintainers.vinetos ];
    mainProgram = "kchat";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    longDescription = ''
      kChat is an instant messaging service which enables you to discuss, share and coordinate your teams in complete
      security via your Internet browser, mobile phone, tablet or computer.
    '';
  };
}
