{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, mkYarnPackage
, fetchYarnDeps
, electron
, element-web
, sqlcipher
, callPackage
, Security
, AppKit
, CoreServices
}:

let
  pinData = lib.importJSON ./pin.json;
  executableName = "element-desktop";
  electron_exec = if stdenv.isDarwin then "${electron}/Applications/Electron.app/Contents/MacOS/Electron" else "${electron}/bin/electron";
in
mkYarnPackage rec {
  pname = "element-desktop";
  inherit (pinData) version;
  name = "${pname}-${version}";
  src = fetchFromGitHub {
    owner = "vector-im";
    repo = "element-desktop";
    rev = "v${version}";
    sha256 = pinData.desktopSrcHash;
  };

  packageJSON = ./element-desktop-package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = pinData.desktopYarnHash;
  };

  nativeBuildInputs = [ makeWrapper ];

  seshat = callPackage ./seshat { inherit CoreServices; };
  keytar = callPackage ./keytar { inherit Security AppKit; };

  buildPhase = ''
    runHook preBuild
    export HOME=$(mktemp -d)
    pushd deps/element-desktop/
    npx tsc
    yarn run i18n
    node ./scripts/copy-res.js
    popd
    rm -rf node_modules/matrix-seshat node_modules/keytar
    ln -s $keytar node_modules/keytar
    ln -s $seshat node_modules/matrix-seshat
    runHook postBuild
  '';

  installPhase = ''
    # resources
    mkdir -p "$out/share/element"
    ln -s '${element-web}' "$out/share/element/webapp"
    cp -r './deps/element-desktop' "$out/share/element/electron"
    cp -r './deps/element-desktop/res/img' "$out/share/element"
    rm "$out/share/element/electron/node_modules"
    cp -r './node_modules' "$out/share/element/electron"
    cp $out/share/element/electron/lib/i18n/strings/en_EN.json $out/share/element/electron/lib/i18n/strings/en-us.json
    ln -s $out/share/element/electron/lib/i18n/strings/en{-us,}.json

    # icons
    for icon in $out/share/element/electron/build/icons/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/element.png"
    done

    # desktop item
    mkdir -p "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/applications"

    # executable wrapper
    # LD_PRELOAD workaround for sqlcipher not found: https://github.com/matrix-org/seshat/issues/102
    makeWrapper '${electron_exec}' "$out/bin/${executableName}" \
      --set LD_PRELOAD ${sqlcipher}/lib/libsqlcipher.so \
      --add-flags "$out/share/element/electron" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}"
  '';

  # Do not attempt generating a tarball for element-web again.
  # note: `doDist = false;` does not work.
  distPhase = ''
    true
  '';

  # The desktop item properties should be kept in sync with data from upstream:
  # https://github.com/vector-im/element-desktop/blob/develop/package.json
  desktopItem = makeDesktopItem {
    name = "element-desktop";
    exec = "${executableName} %u";
    icon = "element";
    desktopName = "Element";
    genericName = "Matrix Client";
    comment = meta.description;
    categories = "Network;InstantMessaging;Chat;";
    extraEntries = ''
      StartupWMClass=element
      MimeType=x-scheme-handler/element;
    '';
  };

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A feature-rich client for Matrix.org";
    homepage = "https://element.io/";
    changelog = "https://github.com/vector-im/element-desktop/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
    inherit (electron.meta) platforms;
  };
}
