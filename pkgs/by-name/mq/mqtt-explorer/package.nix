{
  lib,
  stdenv,
  electron,
  yarn,
  fixup-yarn-lock,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  typescript,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  electronDist = electron + (if stdenv.isDarwin then "/Applications" else "/libexec/electron");
in
# NOTE mqtt-explorer has 3 yarn subpackages and uses relative links
# between them, which makes it hard to package them via 3 `mkYarnPackage`
# since the resulting `node_modules` directories don't have the same structure
# as if they were installed directly. Hence why we opted to use a
# `stdenv.mkDerivation` instead.
stdenv.mkDerivation rec {
  # NOTE official app name is `MQTT-Explorer` but to suffice nixpkgs conventions
  # we opted to use `mqtt-explorer` instead.
  pname = "mqtt-explorer";
  version = "0.4.0-beta.6";

  src = fetchFromGitHub {
    owner = "thomasnordquist";
    repo = "MQTT-Explorer";
    rev = "v${version}";
    hash = "sha256-oFS4RnuWQoicPemZbPBAp8yQjRbhAyo/jiaw8V0MBAo=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-yEL6Vb1Yry3Vns2GF0aagGksRwsCgXR5ZfmrDPxeqos=";
  };

  offlineCacheApp = fetchYarnDeps {
    yarnLock = "${src}/app/yarn.lock";
    hash = "sha256-4oGWBXZHdN+wSpn3fPzTdpaIcywAVdFVYmsOIhcgvUE=";
  };

  offlineCacheBackend = fetchYarnDeps {
    yarnLock = "${src}/backend/yarn.lock";
    hash = "sha256-gg6KrcQz7MdIgFdlbuGiDf/tVd7lSOjwXFIq56tpaTc=";
  };

  nativeBuildInputs = [
    nodejs
    yarn
    typescript
    fixup-yarn-lock
    makeWrapper
  ] ++ lib.optionals (!stdenv.isDarwin) [ copyDesktopItems ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # disable code signing on macos
  # https://github.com/electron-userland/electron-builder/blob/77f977435c99247d5db395895618b150f5006e8f/docs/code-signing.md#how-to-disable-code-signing-during-the-build-process-on-macos
  postConfigure = lib.optionalString stdenv.isDarwin ''
    export CSC_IDENTITY_AUTO_DISCOVERY=false
  '';

  configurePhase = ''
    runHook preConfigure

    # Yarn writes cache directories etc to $HOME.
    export HOME=$TMPDIR

    fixup-yarn-lock yarn.lock
    yarn config --offline set yarn-offline-mirror $offlineCache
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress

    pushd app
    fixup-yarn-lock yarn.lock
    yarn config --offline set yarn-offline-mirror $offlineCacheApp
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    popd

    pushd backend
    fixup-yarn-lock yarn.lock
    yarn config --offline set yarn-offline-mirror $offlineCacheApp
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    popd

    patchShebangs {node_modules,app/node_modules,backend/node_modules}

    cp -r ${electronDist} electron-dist
    chmod -R u+w electron-dist

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    tsc && cd app && yarn --offline run build && cd ..

    yarn --offline run electron-builder --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString (!stdenv.isDarwin) ''
      mkdir -p "$out/share/mqtt-explorer"/{app,icons/hicolor}

      cp -r build/*-unpacked/{locales,resources{,.pak}} "$out/share/mqtt-explorer/app"

      for file in res/appx/Square44x44Logo.targetsize-*_altform-unplated.png; do

        size=$(echo "$file" | sed -n 's/.*targetsize-\([0-9]*\)_altform-unplated\.png/\1/p')

        install -Dm644 \
          "$file" \
          "$out/share/icons/hicolor/''${size}x''${size}/apps/mqtt-explorer.png"
      done

      makeWrapper '${electron}/bin/electron' "$out/bin/mqtt-explorer" \
        --add-flags "$out/share/mqtt-explorer/app/resources/app.asar" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
        --set-default ELECTRON_IS_DEV 0 \
        --inherit-argv0
    ''}

    ${lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/{Applications,bin}
      mv "build/mac/MQTT Explorer.app" $out/Applications

      makeWrapper "$out/Applications/MQTT Explorer.app/Contents/MacOS/MQTT Explorer" \
        $out/bin/mqtt-explorer
    ''}

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    export ELECTRON_OVERRIDE_DIST_PATH=electron-dist/

    yarn test:app --offline
    yarn test:backend --offline

    unset ELECTRON_OVERRIDE_DIST_PATH
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = meta.mainProgram;
      icon = "mqtt-explorer";
      desktopName = "MQTT Explorer";
      genericName = "MQTT Protocol Client";
      comment = meta.description;
      type = "Application";
      categories = [
        "Development"
        "Utility"
        "Network"
      ];
      startupWMClass = "mqtt-explorer";
    })
  ];

  meta = with lib; {
    description = "An all-round MQTT client that provides a structured topic overview";
    homepage = "https://github.com/thomasnordquist/MQTT-Explorer";
    changelog = "https://github.com/thomasnordquist/MQTT-Explorer/releases/tag/v${version}";
    license = licenses.cc-by-nd-40;
    maintainers = with maintainers; [ tsandrini ];
    platforms = electron.meta.platforms;
    mainProgram = "mqtt-explorer";
  };
}
