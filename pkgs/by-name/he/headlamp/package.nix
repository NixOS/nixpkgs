{
  buildNpmPackage,
  headlamp-server,
  headlamp-frontend,
  electron,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

buildNpmPackage {
  pname = "headlamp";
  inherit (headlamp-server) version src;

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = "${headlamp-server.src.name}/app";

  npmDepsHash = "sha256-FcV2ORs96Rj/OyCbBCBo/ZmcwvjDLPKkn0i4m+0gXIE=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postPatch = ''
    chmod u+w ..
  '';

  npmBuildScript = "compile-electron";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "headlamp";
      desktopName = "Headlamp";
      comment = "An easy-to-use and extensible Kubernetes web UI";
      exec = "headlamp";
      icon = "headlamp";
      categories = [
        "Network"
        "System"
      ];
      startupWMClass = "Headlamp";
    })
  ];

  installPhase = ''
    runHook preInstall

    # Electron app
    install -Dt $out/lib/headlamp/app package.json
    install -Dt $out/lib/headlamp/app/build build/main.js build/preload.js

    # Production dependencies only
    npm prune --omit=dev
    rm -rf node_modules/.bin
    cp -r node_modules $out/lib/headlamp/app/

    # Resources directory (where process.resourcesPath should point)
    mkdir -p $out/lib/headlamp/resources
    cp -r ${headlamp-frontend} $out/lib/headlamp/resources/frontend
    chmod -R u+w $out/lib/headlamp/resources/frontend
    ln -s ${headlamp-server}/bin/headlamp-server $out/lib/headlamp/resources/headlamp-server
    mkdir -p $out/lib/headlamp/resources/.plugins
    cp ${headlamp-server.src}/app/app-build-manifest.json $out/lib/headlamp/resources/

    # i18n locales
    mkdir -p $out/lib/headlamp/resources/frontend/i18n
    cp -r ${headlamp-server.src}/frontend/src/i18n/locales $out/lib/headlamp/resources/frontend/i18n/locales

    # Entry point that sets process.resourcesPath before loading the real main
    cat > $out/lib/headlamp/app/main.js <<ENTRY
    const path = require('path');
    const { app } = require('electron');
    const resourcesPath = path.resolve(__dirname, '..', 'resources');
    Object.defineProperty(process, 'resourcesPath', {
      get: () => resourcesPath,
      configurable: false,
    });
    app.setVersion('${headlamp-server.version}');
    app.setName('Headlamp');
    require('./build/main.js');
    ENTRY

    # Point package.json main at our wrapper
    substituteInPlace $out/lib/headlamp/app/package.json \
      --replace-fail '"main": "build/main.js"' '"main": "main.js"'

    # Icons
    for size in 16 32; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      cp ${headlamp-server.src}/frontend/public/favicon-''${size}x''${size}.png $out/share/icons/hicolor/''${size}x''${size}/apps/headlamp.png
    done
    mkdir -p $out/share/icons/hicolor/192x192/apps
    cp ${headlamp-server.src}/frontend/public/android-chrome-192x192.png $out/share/icons/hicolor/192x192/apps/headlamp.png
    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp ${headlamp-server.src}/frontend/public/android-chrome-512x512.png $out/share/icons/hicolor/512x512/apps/headlamp.png

    # Wrapper
    mkdir -p $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/headlamp \
      --add-flags $out/lib/headlamp/app \
      --prefix PATH : ${headlamp-server}/bin

    runHook postInstall
  '';

  passthru = {
    frontend = headlamp-frontend;
  };

  meta = headlamp-server.meta // {
    mainProgram = "headlamp";
  };
}
