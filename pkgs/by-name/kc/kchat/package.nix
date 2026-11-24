{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "kchat";
  version = "3.5.3";

  src = fetchurl {
    url = "https://download.storage5.infomaniak.com/kchat/kchat-desktop-${finalAttrs.version}-linux-x86_64.AppImage";
    name = "kchat-${finalAttrs.version}.AppImage";
    hash = "sha256-1WlOKVjazzmPuAbJR5woP0sE9EkSxmcsJnZrmTotFYg=";
  };

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/lib/kchat"
    cp -r ${finalAttrs.contents}/{locales,resources} "$out/share/lib/kchat"
    cp -r ${finalAttrs.contents}/usr/* "$out"
    cp "${finalAttrs.contents}/kchat-desktop.desktop" "$out/share/applications/"
    mv "$out/bin/kchat" "$out/bin/kchat" || true
    install -m 444 -D ${finalAttrs.contents}/kchat-desktop.desktop $out/share/applications/kchat-desktop.desktop
    substituteInPlace $out/share/applications/kchat-desktop.desktop --replace-fail 'Exec=AppRun' 'Exec=kchat'
  '';

  meta = {
    description = "Instant messaging service part of Infomaniak KSuite";
    homepage = "https://www.infomaniak.com/en/apps/download-kchat";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.vinetos ];
    mainProgram = "kchat";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    longDescription = ''
      kChat is an instant messaging service which enables you to discuss, share and coordinate your teams in complete
      security via your Internet browser, mobile phone, tablet or computer.
    '';
  };
})
