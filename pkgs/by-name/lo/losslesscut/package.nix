{
  cacert,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  fetchurl,
  ffmpeg-full,
  lib,
  makeDesktopItem,
  makeWrapper,
  mesa,
  nix-update-script,
  stdenvNoCC,
  writableTmpDirAsHomeHook,
  yarn-berry,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "losslesscut";
  version = "3.64.0";

  src = fetchFromGitHub {
    owner = "mifi";
    repo = "lossless-cut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H+tiik78IY6LMG/6dlspiX0CFNTjDxIOhOSE21t7qyA=";
  };

  yarnOfflineCache = stdenvNoCC.mkDerivation {
    name = "${finalAttrs.pname}-${finalAttrs.version}-offline-cache";
    inherit (finalAttrs) src;

    nativeBuildInputs = [
      cacert
      writableTmpDirAsHomeHook
      yarn-berry
    ];

    preConfigure = ''
      yarn config set enableTelemetry false
      yarn config set enableGlobalCache false
      yarn config set supportedArchitectures --json '{"os":["current"], "cpu":["current"], "libc":["current"]}'
      yarn config set cacheFolder $out
    '';

    buildPhase = ''
      runHook preBuild

      yarn install --mode=skip-build

      runHook postBuild
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-kxAFiYtjTPVeM8FvATQjTizxVdQ0XvxLI7naH6+OXa4=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    mesa.drivers
    writableTmpDirAsHomeHook
    yarn-berry
  ];

  postUnpack = ''
    substituteInPlace source/src/main/ffmpeg.ts --replace-fail \
    "function getFfPath(cmd: string) {" \
    "function getFfPath(cmd: string) { return \"${lib.getBin ffmpeg-full}/bin/\" + cmd;} function getFfPath_ORIGINAL(cmd: string) {"

    substituteInPlace source/src/main/i18nCommon.ts --replace-fail \
    "function getLangPath(subPath: string) {" \
    "function getLangPath(subPath: string) { return join(process.env.LOCALES_PATH, subPath);} function getLangPath_ORIGINAL(subPath: string) {"
  '';

  preConfigure = ''
    yarn config set enableTelemetry false
    yarn config set enableGlobalCache false
    yarn config set supportedArchitectures --json '{"os":["current"], "cpu":["current"], "libc":["current"]}'
    yarn config set cacheFolder $yarnOfflineCache
  '';

  buildPhase = ''
    runHook preBuild

    yarn install --mode=skip-build
    yarn run electron-vite build
    yarn run electron-builder --linux --dir \
    -c.electronDist="${electron}/libexec/electron" \
    -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  getIcon = fetchurl {
    url = "https://raw.githubusercontent.com/mifi/lossless-cut/master/src/renderer/src/icon.svg";
    hash = "sha256-09PaP0A84bn4Rq4qOKj+mTj8RYAkNSqXQbWakg7vrPk=";
  };

  installPhase = ''
    runHook preInstall

    makeWrapper "${lib.getExe electron}" $out/bin/losslesscut \
    --inherit-argv0 \
    --add-flags "$out/bin/app.asar" \
    --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
    --set LOCALES_PATH "$out/locales" \
    --set GBM_BACKENDS_PATH "${lib.getLib mesa.drivers}/lib/gbm"

    cp dist/linux-unpacked/resources/app.asar $out/bin
    cp -r dist/linux-unpacked/resources/locales $out
    mkdir -p $out/share/pixmaps
    cp $getIcon $out/share/pixmaps/scalable.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      categories = [ "Utility" ];
      comment = "Swiss army knife of lossless video/audio editing";
      desktopName = "LosslessCut";
      exec = "losslesscut %U";
      icon = "scalable";
      name = "LosslessCut";
      startupWMClass = "losslesscut";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Swiss army knife of lossless video/audio editing";
    homepage = "https://github.com/mifi/lossless-cut";
    changelog = "https://github.com/mifi/lossless-cut/releases/tag/v${finalAttrs.version}";
    mainProgram = "losslesscut";
    platforms = with lib.platforms; [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ KSJ2000 ];
    license = with lib.licenses; [ gpl2Only ];
  };
})
