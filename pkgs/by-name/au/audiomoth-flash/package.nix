{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  iconConvTools,
  electron,
  makeDesktopItem,
  copyDesktopItems,
}:
buildNpmPackage (finalAttrs: {
  pname = "audiomoth-flash";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "OpenAcousticDevices";
    repo = "AudioMoth-Flash-App";
    tag = finalAttrs.version;
    hash = "sha256-VlLW9z9yirLlTMgvwOwp7y7c02Job0/gV4FLBdQld4Y=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  __structuredAttrs = true;
  npmDepsHash = "sha256-zRPKlpC8xNGPn/3lctze7GpkmphEew2da5ER8EaoFnY=";

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

    icoFileToHiColorTheme build/icon.ico audiomoth-flash "$out"

    mkdir -p "$out/share/audiomoth-flash/resources"
    cp dist/linux-unpacked/resources/app.asar "$out/share/audiomoth-flash/resources"

    makeWrapper ${lib.getExe electron} "$out/bin/audiomoth-flash" \
      --add-flags "$out/share/audiomoth-flash/resources/app.asar" \
      --set-default "ELECTRON_FORCE_IS_PACKAGED" "1" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "AudioMoth-Flash";
      desktopName = "AudioMoth-flash";
      exec = "audiomoth-flash";
      icon = "audiomoth-flash";
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
        "flash"
        "flashing"
        "firmware"
      ];
    })
  ];

  meta = {
    description = "application capable of applying new firmware to an AudioMoth device";
    mainProgram = "audiomoth-flash";
    homepage = "https://www.openacousticdevices.info/applications";
    downloadPage = "https://github.com/OpenAcousticDevices/AudioMoth-Flash-App/releases";
    changelog = "https://github.com/OpenAcousticDevices/AudioMoth-Flash-App/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.RossSmyth ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
})
