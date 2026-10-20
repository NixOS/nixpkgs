{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "epic-games-launcher";
  version = "0.98.1+gd6c4f03";

  src = fetchurl {
    url = "https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/${
      builtins.replaceStrings [ "+" ] [ "%2B" ] finalAttrs.version
    }/Linux/EpicGamesLauncher-x86_64.AppImage";
    hash = "sha256-NV1DNkNd3gc4ijspaUbttQHx8fWeePwVAAPsyzDsaKo=";
  };

  extraPkgs =
    pkgs: with pkgs; [
      python3
    ];

  extraInstallCommands =
    let
      appImageContents = appimageTools.extract (with finalAttrs; { inherit pname version src; });
    in
    ''
      install -Dm444 ${appImageContents}/${finalAttrs.pname}.desktop \
        -t $out/share/applications

      substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
        --replace-fail 'Exec=EpicGamesLauncher' 'Exec=${finalAttrs.meta.mainProgram}' \
        --replace-fail 'Icon=EpicGamesLauncher' 'Icon=epic-games'

      install -Dm444 \
        ${appImageContents}/usr/share/icons/hicolor/128x128/apps/EpicGamesLauncher.png \
        $out/share/icons/hicolor/128x128/apps/epic-games.png
    '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Epic Games Launcher for Linux";
    homepage = "https://launcher.epicgames.com/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "epic-games-launcher";
    maintainers = with lib.maintainers; [ Username404-59 ];
  };
})
