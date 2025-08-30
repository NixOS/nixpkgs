{
  buildFHSEnv,
  electron_36,
  fetchFromGitHub,
  fetchYarnDeps,
  git,
  lib,
  makeDesktopItem,
  nodejs,
  stdenvNoCC,
  util-linux,
  yarnBuildHook,
  yarnConfigHook,
  zip,
}:

let
  pname = "electron-fiddle";
  version = "0.37.2";

  src = fetchFromGitHub {
    owner = "electron";
    repo = "fiddle";
    tag = "v${version}";
    hash = "sha256-e9PLgkqWBNLBw7uuNpPluOQ6+aGLYQLyTzcLa+LMOzs=";
  };

  electron = electron_36;

  unwrapped = stdenvNoCC.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version src;

    patches = [ ./dont-use-initial-releases-json.patch ];

    offlineCache = fetchYarnDeps {
      inherit src;
      hash = "sha256-mB8WG6tX204u6AJ8qLbWrA+pSN3oDihHqj0t3bWcuAI=";
    };

    nativeBuildInputs = [
      git
      nodejs
      util-linux
      yarnBuildHook
      yarnConfigHook
      zip
    ];

    preBuild = ''
      # electron files need to be writable on Darwin
      cp -r ${electron.dist} electron-dist
      chmod -R u+w electron-dist

      pushd electron-dist
      zip -0Xqr ../electron.zip .
      popd

      rm -r electron-dist

      # force @electron/packager to use our electron instead of downloading it, even if it is a different version
      substituteInPlace node_modules/@electron/packager/dist/packager.js \
        --replace-fail 'await this.getElectronZipPath(downloadOpts)' '"electron.zip"'
    '';

    yarnBuildScript = "package";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/electron-fiddle/resources"
      cp "out/Electron Fiddle-"*/resources/app.asar "$out/lib/electron-fiddle/resources/"
      mkdir -p "$out/share/icons/hicolor/scalable/apps"
      cp assets/icons/fiddle.svg "$out/share/icons/hicolor/scalable/apps/electron-fiddle.svg"

      runHook postInstall
    '';
  };

  desktopItem = makeDesktopItem {
    name = "electron-fiddle";
    desktopName = "Electron Fiddle";
    comment = "The easiest way to get started with Electron";
    genericName = "Electron Fiddle";
    exec = "electron-fiddle %U";
    icon = "electron-fiddle";
    startupNotify = true;
    categories = [
      "GNOME"
      "GTK"
      "Utility"
    ];
    mimeTypes = [ "x-scheme-handler/electron-fiddle" ];
  };

in
buildFHSEnv {
  inherit pname version;
  runScript = "${lib.getExe electron} ${unwrapped}/lib/electron-fiddle/resources/app.asar";

  extraInstallCommands = ''
    mkdir -p "$out/share/icons/hicolor/scalable/apps"
    ln -s "${unwrapped}/share/icons/hicolor/scalable/apps/electron-fiddle.svg" "$out/share/icons/hicolor/scalable/apps/"
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications"/*.desktop "$out/share/applications/"
  '';

  targetPkgs =
    pkgs:
    with pkgs;
    map lib.getLib [
      # for electron-fiddle itself
      udev

      # for running Electron 22.0.0 inside
      alsa-lib
      atk
      cairo
      cups
      dbus
      expat
      glib
      gtk3
      libdrm
      libglvnd
      libnotify
      libxkbcommon
      libgbm
      nspr
      nss
      pango
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxcb

      # for running Electron before 18.3.5/19.0.5/20.0.0 inside
      gdk-pixbuf

      # for running Electron before 16.0.0 inside
      xorg.libxshmfence

      # for running Electron before 11.0.0 inside
      xorg.libXcursor
      xorg.libXi
      xorg.libXrender
      xorg.libXtst

      # for running Electron before 10.0.0 inside
      xorg.libXScrnSaver

      # for running Electron before 8.0.0 inside
      libuuid

      # for running Electron before 4.0.0 inside
      fontconfig

      # for running Electron before 3.0.0 inside
      gnome2.GConf

      # Electron 2.0.8 is the earliest working version, due to
      # https://github.com/electron/electron/issues/13972
    ];

  meta = with lib; {
    description = "Easiest way to get started with Electron";
    homepage = "https://www.electronjs.org/fiddle";
    license = licenses.mit;
    mainProgram = "electron-fiddle";
    maintainers = with maintainers; [
      andersk
      tomasajt
    ];
    platforms = electron.meta.platforms;
  };
}
