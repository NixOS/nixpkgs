{ lib
, mkYarnPackage
, fetchurl
, makeWrapper
, electron
, zip
, unzip
, runCommandNoCC
, git
}: let
  electronZip = runCommandNoCC "electronZip-${electron.version}" { buildInputs = [ electron zip ]; }
  ''
    cp -r ${electron}/libexec/electron/ .
    chmod -R 777 .
    mkdir -p $out
    zip -r $out/electron-v29.0.1-linux-x64.zip .
  '';

  mainProgram = "proton-mail";
  version = "1.0.2";

in mkYarnPackage {
  pname = "protonmail-desktop";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ProtonMail/inbox-desktop/releases/download/v${version}/desktop-release-${version}.zip";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    electron
    # fakeroot
    makeWrapper
    zip
    unzip
    git

    # nodePackages."@electron-forge/cli"
  ];

  env = {
    DEBUG = "electron-forge:electron-packager";
    # ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    ELECTRON_OVERRIDE_DIST_PATH = "${electron}/bin/";
  };

  /*packageJSON = "$src/package.json";

  offlineCache = fetchYarnDeps {
    yarnLock = "$/yarn.lock";
    hash = lib.fakeHash;
  };

  # yarnPreBuild = "";
  # yarnPostBuild = "";*/

  buildPhase = ''
    # set -x

    pushd deps/proton-mail
    rm proton-mail

    substituteInPlace forge.config.ts \
      --replace-fail "@ELECTRON_ZIP@" "${electronZip}"

    popd

    export HOME=$(mktemp -d)
    # ./node_modules/.bin/electron-forge package -a x64 -p linux
    yarn --offline run package -a x64 -p linux
  '';

  preFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/${mainProgram} \
      --add-flags $out/share/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  meta = {
    description = "Desktop application for Mail and Calendar, made with Electron";
    homepage = "https://github.com/ProtonMail/inbox-desktop";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rsniezek sebtm ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    inherit mainProgram;
  };
}

