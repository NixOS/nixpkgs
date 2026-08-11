{
  buildFHSEnv,
  fetchFromGitHub,
  fetchYarnDeps,
  electron,
  git,
  lib,
  makeDesktopItem,
  nodejs,
  stdenvNoCC,
  util-linux,
  yarn-berry_4,
  zip,
}:

let
  pname = "electron-fiddle";
  version = "0.40.1";
  yarn-berry = yarn-berry_4;

  src = fetchFromGitHub {
    owner = "electron";
    repo = "fiddle";
    tag = "v${version}";
    hash = "sha256-nmmj1PvW9LOoEdwwWRRXe9q9J8z6Fp45Tt038BjWD+k=";
  };

  patches = [
    ./dont-use-initial-releases-json.patch
    ./dont-fetch-contributors.patch

    # zip extraction fails on newer nodejs versions without this fix
    ./bump-yauzl.patch

    # https://github.com/nixos/nixpkgs/issues/542343
    ./yarn-metadata-version.patch
  ];

  missingHashes = ./missing-hashes.json;

  unwrapped = stdenvNoCC.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit
      version
      src
      patches
      missingHashes
      ;

    offlineCache = yarn-berry.fetchYarnBerryDeps {
      inherit src patches missingHashes;
      hash = "sha256-xxguRiyZDGdVt3eYh+KUI/odLZZ/LeScRBfexMxAOVI=";
    };

    nativeBuildInputs = [
      git
      nodejs
      util-linux
      yarn-berry
      yarn-berry.yarnBerryConfigHook
      zip
    ];

    buildPhase = ''
      runHook preBuild

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

      node --run package

      runHook postBuild
    '';

    # electron-forge's console output is squeezed into one narrow column if unset
    env.CI = "1";

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

  passthru = { inherit unwrapped; };

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
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxcb

      # for running Electron before 18.3.5/19.0.5/20.0.0 inside
      gdk-pixbuf

      # for running Electron before 16.0.0 inside
      libxshmfence

      # for running Electron before 11.0.0 inside
      libxcursor
      libxi
      libxrender
      libxtst

      # for running Electron before 10.0.0 inside
      libxscrnsaver

      # for running Electron before 8.0.0 inside
      libuuid

      # for running Electron before 4.0.0 inside
      fontconfig

      # Electron 3.0.0 is the earliest working version, since GConf was removed
      # from Nixpkgs
    ];

  meta = {
    description = "Easiest way to get started with Electron";
    homepage = "https://www.electronjs.org/fiddle";
    license = lib.licenses.mit;
    mainProgram = "electron-fiddle";
    maintainers = with lib.maintainers; [
      andersk
      tomasajt
    ];
    platforms = electron.meta.platforms;
  };
}
