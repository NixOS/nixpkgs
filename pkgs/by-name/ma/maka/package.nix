{
  lib,
  stdenv,
  buildNpmPackage,
  callPackage,
  fetchurl,
  nodejs_24,
  electron_43,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  unzip,
  gitMinimal,
  libicns,
  ripgrep,
  versionCheckHook,
  withDesktop ? false,
}:

let
  electron = electron_43;
  nodejs = nodejs_24;
  resourcesDirectory =
    if stdenv.hostPlatform.isDarwin then
      "apps/desktop/release/mac-${stdenv.hostPlatform.node.arch}/Maka.app/Contents/Resources"
    else
      "apps/desktop/release/linux${lib.optionalString stdenv.hostPlatform.isAarch64 "-arm64"}-unpacked/resources";
in
buildNpmPackage (finalAttrs: {
  pname = if withDesktop then "maka-desktop" else "maka";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchurl {
    url = "mirror://apache/incubator/maka/${finalAttrs.version}-incubating/apache-maka-${finalAttrs.version}-incubating-src.tar.gz";
    hash = "sha256-ON8Wc+Dnikfatamef1rujXv1wSTrMxx0an2Aiz97UaA=";
  };

  inherit nodejs;
  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-d00oOxQUoqmC7wMVb5sQxCmsCnUrlmM7/Bz6a/5IuIk=";
  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals withDesktop [
    copyDesktopItems
    unzip
  ]
  ++ lib.optionals (withDesktop && stdenv.hostPlatform.isDarwin) [ libicns ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    npm_config_build_from_source = "true";
    CSC_IDENTITY_AUTO_DISCOVERY = "false";
  };

  patches = lib.optionals withDesktop [ ./disable-updates.patch ];

  preBuild = ''
    npm rebuild esbuild node-pty
    node scripts/apply-dependency-patches.mjs

    for directory in node_modules/fs-native-extensions/prebuilds/*; do
      if [ "$(basename "$directory")" != "${stdenv.hostPlatform.node.platform}-${stdenv.hostPlatform.node.arch}" ]; then
        rm --recursive "$directory"
      fi
    done
    rm node_modules/fs-native-extensions/prebuilds/*/*.bare
  '';

  buildPhase = ''
    runHook preBuild

    npm run build:workspace-deps --workspace maka-agent
    npm run build --workspace maka-agent
  ''
  + lib.optionalString withDesktop ''
    npm run build --workspace @maka/computer-use
    npm run build --workspace @maka/ui
    npm run build --workspace @maka/desktop
  ''
  + lib.optionalString (withDesktop && stdenv.hostPlatform.isLinux) ''
    node --input-type=module --eval '
      import { readFileSync, writeFileSync } from "node:fs";
      const filename = "apps/desktop/package.json";
      const manifest = JSON.parse(readFileSync(filename, "utf8"));
      manifest.main = "dist/main/nix-main.cjs";
      writeFileSync(filename, JSON.stringify(manifest));
    '
    cat > apps/desktop/dist/main/nix-main.cjs <<'EOF'
    Object.defineProperty(process, "resourcesPath", {
      value: require("node:path").dirname(require("electron").app.getAppPath()),
    });
    import("./main.js");
    EOF
  ''
  + lib.optionalString withDesktop ''

    mkdir --parents native/runtime-host-peer/target/release
    cp ${finalAttrs.passthru.runtimeHostPeer}/lib/maka_runtime_host_peer.node \
      native/runtime-host-peer/target/release/

    ${
      if stdenv.hostPlatform.isDarwin then
        "unzip -q ${electron.src} -d electron-dist"
      else
        "cp --recursive ${electron.dist} electron-dist"
    }
    mkdir --parents node_modules/electron/dist
    cp electron-dist/LICENSE* node_modules/electron/dist/

  ''
  + lib.optionalString (withDesktop && stdenv.hostPlatform.isDarwin) ''
    png2icns apps/desktop/build/icon.icns apps/desktop/assets/app-icons/sky.png
  ''
  + lib.optionalString withDesktop ''

    pushd apps/desktop
    ../../node_modules/.bin/electron-builder --dir \
      --config electron-builder.config.mjs \
      --config.electronDist=../../electron-dist \
      --config.electronVersion=${electron.version} \
      --config.npmRebuild=false \
      --config.mac.identity=null \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "--config.mac.icon=build/icon.icns"} \
      --config.mac.forceCodeSigning=false \
      --config.mac.notarize=false
    popd
  ''
  + ''
    runHook postBuild
  '';

  doCheck = withDesktop;
  checkPhase = ''
    runHook preCheck
    node --input-type=module --eval '
      import { access } from "node:fs/promises";
      import {
        assertPackagedDependencyClosure,
        assertPackagedResources,
      } from "./scripts/verify-packaged-app.mjs";
      const resources = process.argv[1];
      await assertPackagedResources(resources, { requirePath: access });
      await assertPackagedDependencyClosure(resources);
      await access(resources + "/app.asar.unpacked/node_modules/node-pty/build/Release/pty.node");
    ' ${lib.escapeShellArg resourcesDirectory}
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
  ''
  + (
    if withDesktop then
      lib.optionalString stdenv.hostPlatform.isDarwin ''
        mkdir --parents "$out/Applications" "$out/bin"
        cp --recursive apps/desktop/release/mac*/Maka.app "$out/Applications/"
        wrapProgram "$out/Applications/Maka.app/Contents/MacOS/Maka" \
          --prefix PATH : ${
            lib.makeBinPath [
              gitMinimal
              nodejs
              ripgrep
            ]
          }
        ln --symbolic "$out/Applications/Maka.app/Contents/MacOS/Maka" "$out/bin/maka-desktop"
      ''
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        mkdir --parents "$out/lib/maka-desktop"
        cp --recursive apps/desktop/release/linux*-unpacked/resources "$out/lib/maka-desktop/"
        install -Dm644 apps/desktop/assets/app-icons/sky.png \
          "$out/share/icons/hicolor/1024x1024/apps/maka-desktop.png"
        makeWrapper ${lib.getExe electron} "$out/bin/maka-desktop" \
          --add-flags "$out/lib/maka-desktop/resources/app.asar" \
          --prefix PATH : ${
            lib.makeBinPath [
              gitMinimal
              nodejs
              ripgrep
            ]
          }
      ''
    else
      ''
        npm prune --omit=dev --ignore-scripts --legacy-peer-deps
        mkdir --parents "$out/lib/maka/packages" "$out/lib/maka/native/runtime-host-peer/target/release"
        cp --recursive node_modules "$out/lib/maka/"
        for workspace in core storage mcp runtime runtime-host eval cli; do
          mkdir --parents "$out/lib/maka/packages/$workspace"
          cp --recursive packages/"$workspace"/{dist,package.json} "$out/lib/maka/packages/$workspace/"
          if [ -d packages/"$workspace"/node_modules ]; then
            cp --recursive packages/"$workspace"/node_modules "$out/lib/maka/packages/$workspace/"
          fi
        done
        find "$out/lib/maka/node_modules/@maka" -xtype l -delete
        cp --recursive packages/eval/harbor "$out/lib/maka/packages/eval/"
        cp LICENSE NOTICE DISCLAIMER-WIP "$out/lib/maka/"
        cp packages/cli/{THIRD_PARTY_NOTICES.txt,RUNTIME_HOST_PEER_THIRD_PARTY_NOTICES.txt} "$out/lib/maka/"
        cp ${finalAttrs.passthru.runtimeHostPeer}/lib/maka_runtime_host_peer.node \
          "$out/lib/maka/native/runtime-host-peer/target/release/"
        makeWrapper ${lib.getExe nodejs} "$out/bin/maka" \
          --add-flags "$out/lib/maka/packages/cli/dist/cli.js" \
          --prefix PATH : ${
            lib.makeBinPath [
              gitMinimal
              ripgrep
            ]
          }
      ''
  )
  + ''
    runHook postInstall
  '';

  desktopItems = lib.optionals withDesktop [
    (makeDesktopItem {
      name = "maka-desktop";
      desktopName = "Maka";
      comment = "Agent workspace";
      exec = "maka-desktop %U";
      icon = "maka-desktop";
      categories = [ "Development" ];
      startupWMClass = "Maka";
    })
  ];

  doInstallCheck = !withDesktop;
  nativeInstallCheckInputs = lib.optionals (!withDesktop) [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.runtimeHostPeer = callPackage ./runtime-host-peer.nix {
    inherit (finalAttrs) src version;
  };

  meta = {
    description = if withDesktop then "Desktop agent workspace" else "Command-line agent workspace";
    homepage = "https://github.com/apache/maka";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ sheeeng ];
    mainProgram = finalAttrs.pname;
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
