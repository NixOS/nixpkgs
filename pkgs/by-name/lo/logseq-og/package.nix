{
  lib,
  stdenv,
  clang_20,

  fetchFromGitHub,
  fetchYarnDeps,
  replaceVars,
  writeShellScriptBin,

  copyDesktopItems,
  cctools,
  clojure,
  darwin,
  makeDesktopItem,
  makeWrapper,
  nodejs-slim,
  removeReferencesTo,
  yarnBuildHook,
  yarnConfigHook,
  xcbuild,
  zip,

  electron_43,
  git,
}:

let
  electron = electron_43;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "logseq-og";
  version = "1.0.0-unstable-2026-05-28";

  src = fetchFromGitHub {
    owner = "logseq";
    repo = "og";
    rev = "6e7afa8eb040686ff057156ee877193b581dd369";
    hash = "sha256-LJuZDyfGQW28ARn9RTqQ1bRI1htfoqt8zhb6UuJLek0=";
  };

  patches = [
    (replaceVars ./hardcode-git-paths.patch {
      cljs_time_src = fetchFromGitHub {
        owner = "logseq";
        repo = "cljs-time";
        rev = "5704fbf48d3478eedcf24d458c8964b3c2fd59a9";
        hash = "sha256-IApL+SEm7AhbTN7J/1KiAKTx7rd53hchRh3jmPQ412g=";
      };
      bb_tasks_src = fetchFromGitHub {
        owner = "logseq";
        repo = "bb-tasks";
        rev = "70d3edeb287f5cec7192e642549a401f7d6d4263";
        hash = "sha256-xVJj5XCkqfaNjnhYZkuqTSJN0ry8UVMaN44r9pxggB0=";
      };
    })

    ./electron-forge-package-instead-of-make.patch
    ./electron-forge-disable-signing.patch

    # See: https://github.com/logseq/og/issues/32
    # See: https://github.com/logseq/og/pull/50
    ./fix-electron-40-and-above.patch
  ];

  mavenRepo = stdenv.mkDerivation {
    name = "logseq-og-${finalAttrs.version}-maven-deps";
    inherit (finalAttrs) src patches;

    nativeBuildInputs = [ clojure ];

    buildPhase = ''
      runHook preBuild

      export HOME="$(mktemp -d)"
      mkdir -p "$out"

      # -P       -> resolve all normal deps
      # -M:alias -> resolve extra-deps of the listed aliases
      clj -Sdeps "{:mvn/local-repo \"$out\"}" -P -M:cljs

      runHook postBuild
    '';

    # copied from buildMavenPackage
    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      runHook preInstall

      find $out -type f \( \
        -name \*.lastUpdated \
        -o -name resolver-status.properties \
        -o -name _remote.repositories \) \
        -delete

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-gcq9zP5AQtpZU7sC9Oq3PkTj6uDo2NSShigkcuglV98=";
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
  };

  yarnOfflineCacheRoot = fetchYarnDeps {
    name = "logseq-og-${finalAttrs.version}-yarn-deps-root";
    inherit (finalAttrs) src patches;
    hash = "sha256-BHf63Y19W9Zl/r5rHQ77voBQykQL1s3gR8SJZRxexZs=";
  };

  # ./static and ./resources are combined into ./static by the build process
  # ./static contains the lockfile and ./resources contains everything else
  yarnOfflineCacheStaticResources = fetchYarnDeps {
    name = "logseq-og-${finalAttrs.version}-yarn-deps-static-resources";
    inherit (finalAttrs) src patches;
    postPatch = "cd ./static";
    hash = "sha256-nxTsE63pw1m2YE4WJhEAg4lQRPKBjnu/8r2WjvgfQGQ=";
  };

  yarnOfflineCacheAmplify = fetchYarnDeps {
    name = "logseq-og-${finalAttrs.version}-yarn-deps-amplify";
    inherit (finalAttrs) src patches;
    postPatch = "cd ./packages/amplify";
    hash = "sha256-IOhSwIf5goXCBDGHCqnsvWLf3EUPqq75xfQg55snIp4=";
  };

  yarnOfflineCacheTldraw = fetchYarnDeps {
    name = "logseq-og-${finalAttrs.version}-yarn-deps-tldraw";
    inherit (finalAttrs) src patches;
    postPatch = "cd ./tldraw";
    hash = "sha256-CtMl3MPlyO5nWfFhCC1SLb/+1HUM3YfFATAPqJg3rUo=";
  };

  # this and related code below is only needed for regenerating lsplugin.*.js
  yarnOfflineCacheLibs = fetchYarnDeps {
    name = "logseq-og-${finalAttrs.version}-yarn-deps-libs";
    inherit (finalAttrs) src patches;
    postPatch = "cd ./libs";
    hash = "sha256-m5ZwYpRrTUeSFfbeViBcABaP2bAhY6p/ZQptmU4YxFY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs =
    let
      clojureWithCache = writeShellScriptBin "clojure" ''
        exec ${lib.getExe' clojure "clojure"} -Sdeps '{:mvn/local-repo "${finalAttrs.mavenRepo}"}' "$@"
      '';

      # the build process runs `git describe --long --always --dirty`
      fakeGit = writeShellScriptBin "git" ''
        echo "${finalAttrs.src.rev or finalAttrs.version}@nixpkgs"
      '';
    in
    [
      clojureWithCache
      copyDesktopItems
      fakeGit
      makeWrapper
      nodejs-slim
      nodejs-slim.npm
      (nodejs-slim.python.withPackages (ps: [ ps.setuptools ]))
      removeReferencesTo
      yarnBuildHook
      yarnConfigHook
      zip
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
      darwin.autoSignDarwinBinariesHook
      xcbuild
      clang_20 # newer clang breaks node-addon-api on darwin
    ];

  # we'll run the hook manually multiple times
  dontYarnInstallDeps = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postConfigure = ''
    yarnOfflineCache="$yarnOfflineCacheRoot" yarnConfigHook

    cp resources/package.json static/package.json
    pushd static
    yarnOfflineCache="$yarnOfflineCacheStaticResources" yarnConfigHook
    popd

    pushd packages/amplify
    yarnOfflineCache="$yarnOfflineCacheAmplify" yarnConfigHook
    popd

    pushd tldraw
    cp yarn.lock apps/tldraw-logseq/yarn.lock
    yarnOfflineCache="$yarnOfflineCacheTldraw" yarnConfigHook
    pushd apps/tldraw-logseq
    yarnOfflineCache="$yarnOfflineCacheTldraw" yarnConfigHook
    popd
    popd

    pushd libs
    yarnOfflineCache="$yarnOfflineCacheLibs" yarnConfigHook
    popd

    # this has to be done after everything is set up, because for some reason
    # the shebangs somehow get unpatched... I don't know why...
    patchShebangs node_modules
    patchShebangs static/node_modules
    patchShebangs packages/amplify/node_modules
    patchShebangs tldraw/node_modules
    patchShebangs tldraw/apps/tldraw-logseq/node_modules
    patchShebangs libs/node_modules

    yarn --offline --cwd tldraw postinstall

    export npm_config_nodedir=${nodejs-slim}
    pushd packages/amplify
    npm rebuild --verbose
    popd

    export npm_config_nodedir=${electron.headers}

    # make sure we're using the files regenerated from the .ts files
    rm resources/js/lsplugin.*.js

    pushd libs

    # if we don't remove this, it will wait for Ctrl+C to terminate
    substituteInPlace webpack.config.core.js \
      --replace-fail "config.plugins.push(new BundleAnalyzerPlugin())" ""

    npm run build
    npm run build:core
    mv dist/lsplugin.*.js ../resources/js/

    popd

    pushd static

    # don't use prebuilt binaries for better-sqlite3
    pushd node_modules/better-sqlite3
    rm -r prebuilds
    npm run build-release
    shopt -s extglob
    rm -r build/Release/!(better_sqlite3.node)
    shopt -u extglob
    popd

    # we want to use our own git, don't try downloading it
    substituteInPlace node_modules/dugite/package.json \
      --replace-fail '"postinstall"' '"_postinstall"'

    # this doesn't seem to build with electron.headers
    rm node_modules/macos-alias/binding.gyp

    # the electron-rebuild command deadlocks for some reason, let's just use normal npm rebuild (since we overrode the nodedir anyways)
    npm rebuild --verbose

    # remove most references to electron.headers
    shopt -s globstar
    rm -r node_modules/**/{*.target.mk,config.gypi,Makefile,Release/.deps}
    shopt -u globstar

    popd

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd

    rm -r electron-dist

    substituteInPlace static/node_modules/@electron/packager/dist/packager.js \
      --replace-fail "await this.getElectronZipPath(downloadOpts)" "\"$(pwd)/electron.zip\""

    cp -r static/node_modules resources/node_modules
  '';

  # electron-forge's console output is squeezed into one narrow column if unset
  env.CI = "1";

  yarnBuildScript = "release-electron";

  installPhase = ''
    runHook preInstall

    # remove references to nodejs
    find static/out/*/resources/app/node_modules -type f -executable -exec remove-references-to -t ${nodejs-slim} '{}' \;
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 static/icons/logseq.png "$out/share/icons/hicolor/512x512/apps/logseq-og.png"

    mkdir -p "$out/share/logseq-og"
    cp -r static/out/*/{locales,resources{,.pak}} "$out/share/logseq-og"

    makeWrapper ${lib.getExe electron} "$out/bin/logseq-og" \
        --add-flags "$out/share/logseq-og/resources/app" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
        --set-default LOCAL_GIT_DIRECTORY ${git} \
        --inherit-argv0
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    cp -r static/out/*/Logseq-OG.app "$out/Applications"

    wrapProgram "$out/Applications/Logseq-OG.app/Contents/MacOS/Logseq-OG" \
      --set-default LOCAL_GIT_DIRECTORY ${git}

    makeWrapper "$out/Applications/Logseq-OG.app/Contents/MacOS/Logseq-OG" "$out/bin/logseq-og"
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Logseq-OG";
      desktopName = "Logseq OG";
      exec = "logseq-og %U";
      terminal = false;
      icon = "logseq-og";
      startupWMClass = "Logseq OG";
      comment = "A privacy-first, open-source platform for knowledge management and collaboration.";
      mimeTypes = [ "x-scheme-handler/logseq-og" ];
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Privacy-first, open-source platform for knowledge management and collaboration";
    homepage = "https://github.com/logseq/og";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "logseq-og";
    platforms = electron.meta.platforms;
  };
})
