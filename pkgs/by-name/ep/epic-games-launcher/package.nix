{
  lib,
  appimageTools,
  fetchurl,
  steam,
}:

let
  pname = "epic-games-launcher";
  version = "0.96.0";
  # Build identifier that upstream appends to the version in the download path
  build = "g2fade97";

  src = fetchurl {
    url = "https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/${version}%2B${build}/Linux/EpicGamesLauncher-x86_64.AppImage";
    hash = "sha256-bFzEbu+MgLAXWcx2FUtpogZFsBt5UmRCqFUAkNtdJR4=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
# Windows games run through GE-Proton, which the launcher downloads itself.
# Its `proton` script is `#!/usr/bin/env python3` and needs the same
# multiarch FHS as Steam, so use Steam's runtime env like `heroic` does.
steam.buildRuntimeEnv {
  inherit pname version;

  # AppImage libraries are only needed as 64-bit, Steam provides the 32-bit ones
  extraPkgs =
    pkgs:
    appimageTools.defaultFhsEnvArgs.targetPkgs pkgs
    ++ appimageTools.defaultFhsEnvArgs.multiPkgs pkgs
    ++ [ pkgs.python3 ];

  extraEnv.EGL_DISABLE_SELF_UPDATE = "1";

  runScript = "${appimageContents}/AppRun";

  privateTmp = false;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/usr/share/applications/epic-games-launcher.desktop \
      -t $out/share/applications
    substituteInPlace $out/share/applications/epic-games-launcher.desktop \
      --replace-fail 'Exec=EpicGamesLauncher' 'Exec=epic-games-launcher'

    for size in 32x32 128x128 256x256@2; do
      install -Dm444 ${appimageContents}/usr/share/icons/hicolor/$size/apps/EpicGamesLauncher.png \
        -t $out/share/icons/hicolor/$size/apps
    done
  '';

  passthru = {
    inherit src;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Desktop client for the Epic Games Store";
    homepage = "https://launcher.epicgames.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ no-mood ];
    mainProgram = "epic-games-launcher";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
