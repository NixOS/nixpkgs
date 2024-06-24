{ lib
, fetchurl
, appimageTools
}:

appimageTools.wrapType2 rec {
  pname = "kchat";
  version = "3.3.1";

  src = fetchurl {
    url = "https://download.storage5.infomaniak.com/kchat/kchat-desktop-${version}-linux-x86_64.AppImage";
    name = "kchat-${version}.AppImage";
    hash = "sha256-f9wWgZSPSMP7bLZGfR5F6l/eAVHVhRmF1c7S6/qLgIA=";
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
      install -m 444 -D ${contents}/kchat-desktop.desktop $out/share/applications/kchat-desktop.desktop
      substituteInPlace $out/share/applications/kchat-desktop.desktop --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
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
