{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "kmeet";
  version = "2.1.0";

  src = fetchurl {
    url = "https://download.storage5.infomaniak.com/meet/kmeet-desktop-${finalAttrs.version}-linux-x86_64.AppImage";
    name = "kmeet-${finalAttrs.version}.AppImage";
    hash = "sha256-VkiDS6r+myAu4CfC9RV2HVdoxnOLTHC4xqKSgqyZy30=";
  };

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/lib/kmeet"
    cp -r ${finalAttrs.contents}/{locales,resources} "$out/share/lib/kmeet"
    cp -r ${finalAttrs.contents}/usr/* "$out"
    cp "${finalAttrs.contents}/kMeet.desktop" "$out/share/applications/"
    mv "$out/bin/kmeet" "$out/bin/kmeet" || true
    substituteInPlace $out/share/applications/kMeet.desktop --replace 'Exec=AppRun' 'Exec=kmeet'
  '';

  meta = {
    description = "Organise secure online meetings via your web browser, your mobile, your tablet or your computer";
    homepage = "https://www.infomaniak.com/en/apps/download-kmeet";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.vinetos ];
    mainProgram = "kmeet";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    longDescription = ''
      kMeet allows you to organise secure online meetings via your web browser, your mobile, your tablet or your
      computer.
    '';
  };
})
