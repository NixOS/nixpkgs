{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  iconConvTools,
  makeDesktopItem,
  copyDesktopItems,
}:
buildNpmPackage (finalAttrs: {
  pname = "audiomoth-config";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "OpenAcousticDevices";
    repo = "AudioMoth-Configuration-App";
    tag = finalAttrs.version;
    hash = "sha256-/mlGyCuXukQD9vejl9KKUsj3Yz+hFIrS6q+mGcVnRN8=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  __structuredAttrs = true;
  npmDepsHash = "sha256-2vScxY/TSFx/P3hrpSwPGHfK7LmDgIn+Jr3G2LbXxiI=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    iconConvTools
    copyDesktopItems
  ];

  buildPhase = ''
    runHook preBuild

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm_config_nodedir=${electron.headers} npm exec electron-builder -- \
      --dir \
      --publish never \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null \
      -c.compression=maximum

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    icoFileToHiColorTheme build/icon.ico audiomoth-config "$out"

    mkdir -p "$out/share/audiomoth-config/resources"
    cp dist/linux-unpacked/resources/app.asar "$out/share/audiomoth-config/resources"

    makeWrapper ${lib.getExe electron} "$out/bin/audiomoth-config" \
      --add-flags "$out/share/audiomoth-config/resources/app.asar" \
      --set-default "ELECTRON_FORCE_IS_PACKAGED" "1" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "AudioMoth-Config";
      desktopName = "AudioMoth-Config";
      exec = "audiomoth-config";
      icon = "audiomoth-config";
      terminal = false;
      type = "Application";
      comment = finalAttrs.meta.description;
      categories = [
        "AudioVideo"
        "Audio"
        "Science"
        "Electronics"
        "Settings"
        "HardwareSettings"
        "Development"
      ];
      keywords = [
        "audiomoth"
        "microphone"
        "configure"
      ];
    })
  ];

  meta = {
    description = "application for configuring the functionality of the AudioMoth recording device";
    mainProgram = "audiomoth-config";
    homepage = "https://www.openacousticdevices.info/config-app-guide";
    downloadPage = "https://github.com/OpenAcousticDevices/AudioMoth-Configuration-App/releases";
    changelog = "https://github.com/OpenAcousticDevices/AudioMoth-Configuration-App/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.RossSmyth ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
})
