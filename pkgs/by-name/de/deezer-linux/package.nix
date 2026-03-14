{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  fetchurl,
  p7zip,
  electron,
  vulkan-loader,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  windowsPackageUrl = "https://cdn-content.dzcdn.net/builds/deezer-desktop/8cF2rAuKxLcU1oMDmCYm8Uiqe19Ql0HTySLssdzLkQ9ZWHuDTp2JBtQOvdrFzWPA/win32/x86/7.1.20/DeezerDesktopSetup_7.1.20.exe";

  windowsPackage = fetchurl {
    url = windowsPackageUrl;
    hash = "sha256-SKtzgg/pK2a/YQq6gqDfkHoInlAoQmwu6BJUhvvJ2+4=";
  };
in

buildNpmPackage rec {
  pname = "deezer-linux";
  version = "7.1.20";

  src = fetchFromGitHub {
    owner = "aunetx";
    repo = "deezer-linux";
    tag = "v${version}";
    hash = "sha256-rAHUxryu3gkDv+HHYtT68c4HFrtol/SkztmpmkitgH4=";
  };

  npmDepsHash = "sha256-BDoHWG5IgIpZ5REhzyZLTwm8a2o22wAIUIOBBdbZ5Ro=";

  nativeBuildInputs = [
    p7zip
    electron
    makeWrapper
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  makeCacheWritable = true;

  postPatch = ''
    cp ${./package.json} ./package.json
    cp ${./package-lock.json} ./package-lock.json

    chmod +w package-lock.json
  '';

  configurePhase = ''
    runHook preConfigure

    mkdir {source,app}

    7z x -so ${windowsPackage} '$PLUGINSDIR/app-32.7z' > source/app-32.7z
    7z x -y -bsp0 -bso0 source/app-32.7z -osource

    npm run asar extract "source/resources/app.asar" "app"

    cp .prettierrc.json app/
    npm run prettier -- --write "app/build/*.{js,html}" --config .prettierrc.json --ignore-path /dev/null

    for patch in $(ls patches); do
      echo "Applying patch $patch"
      patch -p 1 -d app < patches/$patch
    done

    cp -r {package.json,package-lock.json,node_modules} app

    cp -r ${electron.dist} app/electron-dist
    chmod -R u+w app/electron-dist

    rm app/electron-dist/libvulkan.so.1
    cp ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 app/electron-dist

    mkdir -p app/resources/linux
    cp extra/linux/* app/resources/linux

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    ./node_modules/.bin/electron-builder \
      --project app \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/lib/deezer-linux
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/lib/deezer-linux

    makeWrapper ${lib.getExe electron} $out/bin/deezer-linux \
      --add-flags $out/share/lib/deezer-linux/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    install -Dm644 icons/512x512.png $out/share/icons/hicolor/512x512/apps/deezer-linux.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "deezer-linux";
      exec = "deezer-linux %U";
      icon = "deezer-linux";
      desktopName = "Deezer";
      comment = "Port of official deezer application";
      mimeTypes = [ "x-scheme-handler/deezer" ];
      categories = [
        "Audio"
        "Music"
        "Player"
        "AudioVideo"
      ];
      startupWMClass = "Deezer";
      terminal = false;
    })
  ];

  meta = {
    description = "An universal linux port of deezer, supporting Flatpak, Appimage, Snap, RPM, DEB";
    homepage = "https://github.com/aunetx/deezer-linux";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "deezer-linux";
    platforms = lib.platforms.all;
  };
}
