{
  lib,
  stdenv,
<<<<<<< HEAD
  fetchFromGitHub,
  yarn-berry,
  nodejs,
  pkg-config,
  node-gyp,
  python3Packages,
  electron_39,
  vips,
  xvfb-run,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
}:
let
  electron = electron_39;
in
stdenv.mkDerivation rec {
  pname = "rocketchat-desktop";
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "RocketChat";
    repo = "Rocket.Chat.Electron";
    tag = version;
    hash = "sha256-ZEjhYjMcCA2ABNfcwe7JbYCoTBHr+geyMSSh6ceBt5g=";
  };

  # This might need to be updated between releases.
  # See https://nixos.org/manual/nixpkgs/stable/#javascript-yarnBerry-missing-hashes
  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-ZAb8zDdxsJYRD6LRhtFS8XRc8NbstJbUyaQCbvSdKSg=";
  };

  nativeBuildInputs = [
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    nodejs # needed for rollup
    # needed for vips compilation for the JS sharp dependency
    pkg-config
    node-gyp
    python3Packages.python
    python3Packages.distutils
    # install phase helpers
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    vips
  ];

  postPatch = ''
    # Avoid downloading a changing file during the `rollup` build
    substituteInPlace rollup.config.mjs \
      --replace-fail 'downloadSupportedVersions(),' ""
  '';

  env = {
    PUPPETEER_SKIP_DOWNLOAD = "1";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_OVERRIDE_DIST_PATH = electron.dist;
    NODE_ENV = "production";
  };

  buildPhase = ''
    runHook preBuild

    yarn build

    # electronDist needs to be writable
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    yarn electron-builder \
        --config electron-builder.json \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  nativeCheckInputs = [
    xvfb-run
  ];

  checkPhase = "yarn test";

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      categories = [
        "GNOME"
        "GTK"
        "Network"
        "InstantMessaging"
      ];
      name = "rocketchat-desktop";
      desktopName = "Rocket.Chat";
      genericName = "Rocket.Chat";
      comment = "Official Desktop Client for Rocket.Chat";
      icon = "rocketchat-desktop";
      exec = "rocketchat-desktop";
      terminal = false;
      startupWMClass = "Rocket.Chat";
      mimeTypes = [ "x-scheme-handler/rocketchat" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications

    cp -a dist/*-unpacked/resources $out/share/rocketchat-desktop

    for icon in build/icons/*.png
    do
      install -Dm644 $icon $out/share/icons/hicolor/$(basename ''${icon%.png})/apps/rocketchat-desktop.png
    done

    makeWrapper '${lib.getExe electron}' $out/bin/rocketchat-desktop \
      --set-default ELECTRON_IS_DEV 0 \
      --add-flags $out/share/rocketchat-desktop/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official Desktop client for Rocket.Chat";
    mainProgram = "rocketchat-desktop";
    homepage = "https://github.com/RocketChat/Rocket.Chat.Electron";
    changelog = "https://github.com/RocketChat/Rocket.Chat.Electron/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mynacol ];
    platforms = lib.platforms.linux;
=======
  pkgs,
  fetchurl,
  wrapGAppsHook3,
}:
let
  libPathNative = { packages }: lib.makeLibraryPath packages;
in
stdenv.mkDerivation rec {
  pname = "rocketchat-desktop";
  version = "4.9.1";

  src = fetchurl {
    url = "https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/${version}/rocketchat-${version}-linux-amd64.deb";
    hash = "sha256-71B5EqsMVGsTvrdl4gLW3O+7/xy2DNv/zROg2CfXl1E=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3 # to fully work with gnome also needs programs.dconf.enable = true in your configuration.nix
  ];

  buildInputs = with pkgs; [
    gtk3
    stdenv.cc.cc
    zlib
    glib
    dbus
    atk
    pango
    freetype
    libgnome-keyring
    fontconfig
    gdk-pixbuf
    cairo
    cups
    expat
    libgpg-error
    alsa-lib
    nspr
    nss
    xorg.libXrender
    xorg.libX11
    xorg.libXext
    xorg.libXdamage
    xorg.libXtst
    xorg.libXcomposite
    xorg.libXi
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXcursor
    xorg.libxkbfile
    xorg.libXScrnSaver
    systemd
    libnotify
    xorg.libxcb
    at-spi2-atk
    at-spi2-core
    libdbusmenu
    libdrm
    libgbm
    xorg.libxshmfence
    libxkbcommon
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    ar p $src data.tar.xz | tar xJ ./opt/ ./usr/
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv opt $out
    mv usr/share $out
    ln -s $out/opt/Rocket.Chat/rocketchat-desktop $out/bin/rocketchat-desktop
    runHook postInstall
  '';

  postFixup =
    let
      libpath = libPathNative { packages = buildInputs; };
    in
    ''
      app=$out/opt/Rocket.Chat
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libpath}:$app" \
        $app/rocketchat-desktop
      sed -i -e "s|Exec=.*$|Exec=$out/bin/rocketchat-desktop|" $out/share/applications/rocketchat-desktop.desktop
    '';

  meta = with lib; {
    description = "Official Desktop client for Rocket.Chat";
    mainProgram = "rocketchat-desktop";
    homepage = "https://github.com/RocketChat/Rocket.Chat.Electron";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
