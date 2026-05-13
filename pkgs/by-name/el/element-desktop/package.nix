{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  nodejs,
  electron_41,
  element-web,
  callPackage,
  typescript,
  tsx,
  sqlcipher,
  # command line arguments which are always set
  commandLineArgs ? "",
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  asar,
  copyDesktopItems,
  darwin,
  actool,
}:

let
  pnpm = pnpm_10;
  electron = electron_41;
  seshat = callPackage ./seshat { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "element-desktop";
  version = "1.12.14";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yy7CfMOMT1DBXHDHaDyAaOgp3s2KQIKA1A6zUhVOUhM=";
  };

  pnpmDeps = fetchPnpmDeps {
    pname = "element";
    inherit (finalAttrs)
      version
      src
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-0yqWObZtRntsH7gk+OB8pMuWsrvCQ4L9173Qv0o5abk=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    asar
    copyDesktopItems
    nodejs
    makeWrapper
    typescript
    pnpm
    pnpmConfigHook
    tsx
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
    actool
  ];

  inherit seshat;

  postPatch = ''
    cd apps/desktop

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    # `@electron/fuses` tries to run `codesign` and fails. Disable and use autoSignDarwinBinariesHook instead
    substituteInPlace ./electron-builder.ts \
      --replace-fail "resetAdHocDarwinSignature:" "// resetAdHocDarwinSignature:"

    # Need to disable asar integrity check to copy in native seshat files, see postBuild phase
    substituteInPlace ./electron-builder.ts \
      --replace-fail "enableEmbeddedAsarIntegrityValidation: true" "enableEmbeddedAsarIntegrityValidation: false"

    cd ../../
  '';

  buildPhase = ''
    runHook preBuild

    export VERSION=${finalAttrs.version}

    pnpm -C apps/desktop run build:ts
    pnpm -C apps/desktop run build:res
    pnpm -C apps/desktop exec electron-builder --dir -c.electronDist=electron-dist -c.electronVersion=${electron.version} -c.mac.identity=null

    cd apps/desktop

    # relative path to app.asar differs on Linux and MacOS
    packed=$(find ./dist -name app.asar)
    asar extract "$packed" tmp-app

    # linking here leads to Error: tmp-app/node_modules/matrix-seshat: file ... links out of the package
    cp -r $seshat tmp-app/node_modules/matrix-seshat

    asar pack tmp-app "$packed"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications" "$out/bin"
    mv dist/mac*/Element.app "$out/Applications"

    ln -s '${element-web}' "$out/Applications/Element.app/Contents/Resources/webapp"

    wrapProgram "$out/Applications/Element.app/Contents/MacOS/Element" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    makeWrapper "$out/Applications/Element.app/Contents/MacOS/Element" "$out/bin/element-desktop"
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p "$out/bin" "$out/share"

    cp -a dist/*-unpacked/resources $out/share/element

    ln -s '${element-web}' "$out/share/element/webapp"

    # icon, used in makeDesktopItem
    mkdir -p "$out/share/icons/hicolor/512x512/apps"
    ln -s "$out/share/element/build/icon.png" "$out/share/icons/hicolor/512x512/apps/element.png"

    # executable wrapper
    makeWrapper '${lib.getExe electron}' "$out/bin/element-desktop" \
      --add-flags "$out/share/element/app.asar" \
      --set LD_PRELOAD ${sqlcipher}/lib/libsqlcipher.so \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  ''
  + ''
    runHook postInstall
  '';

  # The desktop item properties should be kept in sync with data from upstream:
  # https://github.com/element-hq/element-desktop/blob/develop/package.json
  desktopItems = [
    (makeDesktopItem {
      name = "element-desktop";
      exec = "element-desktop %u";
      icon = "element";
      desktopName = "Element";
      genericName = "Matrix Client";
      comment = finalAttrs.meta.description;
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      startupWMClass = "Element";
      mimeTypes = [
        "x-scheme-handler/element"
        "x-scheme-handler/io.element.desktop"
      ];
    })
  ];

  stripDebugList = lib.optionals stdenv.hostPlatform.isDarwin [
    "Applications/Element.app/Contents/MacOS"
  ];

  meta = {
    description = "Feature-rich client for Matrix.org";
    homepage = "https://element.io/";
    changelog = "https://github.com/element-hq/element-web/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    teams = [ lib.teams.matrix ];
    inherit (electron.meta) platforms;
    mainProgram = "element-desktop";
  };
})
