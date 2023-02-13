{ lib
, element-desktop # for seshat and keytar
, schildichat-web
, stdenv
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, fetchYarnDeps
, yarn
, nodejs
, fixup_yarn_lock
, electron
, Security
, AppKit
, CoreServices
, sqlcipher
}:

let
  pinData = lib.importJSON ./pin.json;
  executableName = "schildichat-desktop";
in
stdenv.mkDerivation rec {
  pname = "schildichat-desktop";
  inherit (pinData) version;

  src = fetchFromGitHub {
    owner = "SchildiChat";
    repo = "schildichat-desktop";
    inherit (pinData) rev;
    sha256 = pinData.srcHash;
    fetchSubmodules = true;
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/element-desktop/yarn.lock";
    sha256 = pinData.desktopYarnHash;
  };

  nativeBuildInputs = [ yarn fixup_yarn_lock nodejs makeWrapper copyDesktopItems ];
  inherit (element-desktop) seshat keytar;

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    pushd element-desktop
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    rm -rf node_modules/matrix-seshat node_modules/keytar
    ln -s $keytar node_modules/keytar
    ln -s $seshat node_modules/matrix-seshat
    patchShebangs node_modules/
    popd

    runHook postConfigure
  '';

  # Only affects unused scripts in $out/share/element/electron/scripts. Also
  # breaks because there are some `node`-scripts with a `npx`-shebang and
  # this shouldn't be in the closure just for unused scripts.
  dontPatchShebangs = true;

  buildPhase = ''
    runHook preBuild

    pushd element-desktop
    yarn --offline run build:ts
    yarn --offline run i18n
    yarn --offline run build:res
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # resources
    mkdir -p "$out/share/element"
    ln -s '${schildichat-web}' "$out/share/element/webapp"
    mv element-desktop "$out/share/element/electron"
    cp -r "$out/share/element/electron/res/img" "$out/share/element"
    cp $out/share/element/electron/lib/i18n/strings/en_EN.json $out/share/element/electron/lib/i18n/strings/en-us.json
    ln -s $out/share/element/electron/lib/i18n/strings/en{-us,}.json

    # icons
    for icon in $out/share/element/electron/build/icons/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/schildichat.png"
    done

    # executable wrapper
    # LD_PRELOAD workaround for sqlcipher not found: https://github.com/matrix-org/seshat/issues/102
    makeWrapper '${electron}/bin/electron' "$out/bin/${executableName}" \
      --set LD_PRELOAD ${sqlcipher}/lib/libsqlcipher.so \
      --add-flags "$out/share/element/electron" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  # The desktop item properties should be kept in sync with data from upstream:
  # https://github.com/schildichat/element-desktop/blob/sc/package.json
  desktopItems = [
    (makeDesktopItem {
      name = "schildichat-desktop";
      exec = "${executableName} %u";
      icon = "schildichat";
      desktopName = "SchildiChat";
      genericName = "Matrix Client";
      comment = meta.description;
      categories = [ "Network" "InstantMessaging" "Chat" ];
      startupWMClass = "schildichat";
      mimeTypes = [ "x-scheme-handler/element" ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Matrix client / Element Desktop fork";
    homepage = "https://schildi.chat/";
    changelog = "https://github.com/SchildiChat/schildichat-desktop/releases";
    maintainers = teams.matrix.members ++ (with maintainers; [ kloenk yuka ]);
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
