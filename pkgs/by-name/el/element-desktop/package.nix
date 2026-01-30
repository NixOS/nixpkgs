{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  nodejs,
  electron_39,
  element-web,
  sqlcipher,
  callPackage,
  typescript,
  # command line arguments which are always set
  commandLineArgs ? "",
  yarnConfigHook,
  yarnBuildHook,
  fetchYarnDeps,
  asar,
  copyDesktopItems,
  darwin,
}:

let
  pinData = import ./element-desktop-pin.nix;
  inherit (pinData.hashes) desktopSrcHash desktopYarnHash;
  executableName = "element-desktop";
  electron = electron_39;
  seshat = callPackage ./seshat { };
in
stdenv.mkDerivation (
  finalAttrs:
  removeAttrs pinData [ "hashes" ]
  // {
    pname = "element-desktop";
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    src = fetchFromGitHub {
      owner = "element-hq";
      repo = "element-desktop";
      rev = "v${finalAttrs.version}";
      hash = desktopSrcHash;
    };

    offlineCache = fetchYarnDeps {
      yarnLock = finalAttrs.src + "/yarn.lock";
      hash = desktopYarnHash;
    };

    env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    nativeBuildInputs = [
      asar
      copyDesktopItems
      nodejs
      makeWrapper
      typescript
      yarnConfigHook
      yarnBuildHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.autoSignDarwinBinariesHook
    ];

    inherit seshat;

    # Only affects unused scripts in $out/share/element/electron/scripts. Also
    # breaks because there are some `node`-scripts with a `npx`-shebang and
    # this shouldn't be in the closure just for unused scripts.
    dontPatchShebangs = true;

    postPatch = ''
      cp -r ${electron.dist} electron-dist
      chmod -R u+w electron-dist

      substituteInPlace package.json \
        --replace-fail \
        ' electron-builder",' \
        ' electron-builder --dir -c.electronDist=electron-dist -c.electronVersion=${electron.version} -c.mac.identity=null",'

      # `@electron/fuses` tries to run `codesign` and fails. Disable and use autoSignDarwinBinariesHook instead
      substituteInPlace ./electron-builder.ts \
        --replace-fail "resetAdHocDarwinSignature:" "// resetAdHocDarwinSignature:"

      # Need to disable asar integrity check to copy in native seshat files, see postBuild phase
      substituteInPlace ./electron-builder.ts \
        --replace-fail "enableEmbeddedAsarIntegrityValidation: true" "enableEmbeddedAsarIntegrityValidation: false"
    '';

    preBuild = ''
      # Apply upstream patch
      # Can be removed if upstream removes patches/@types+auto-launch+5.0.5.patch introduced in
      # https://github.com/element-hq/element-desktop/commit/5e882f8e08d58bf9663c8e3ab33885bf7b3709de
      node ./node_modules/patch-package/index.js
    '';

    postBuild = ''
      # relative path to app.asar differs on Linux and MacOS
      packed=$(find ./dist -name app.asar)
      asar extract "$packed" tmp-app

      # linking here leads to Error: tmp-app/node_modules/matrix-seshat: file ... links out of the package
      cp -r $seshat tmp-app/node_modules/matrix-seshat

      asar pack tmp-app "$packed"
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

      makeWrapper "$out/Applications/Element.app/Contents/MacOS/Element" "$out/bin/${executableName}"
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      mkdir -p "$out/bin" "$out/share"

      cp -a dist/*-unpacked/resources $out/share/element

      ln -s '${element-web}' "$out/share/element/webapp"

      # icon, used in makeDesktopItem
      mkdir -p "$out/share/icons/hicolor/512x512/apps"
      ln -s "$out/share/element/build/icon.png" "$out/share/icons/hicolor/512x512/apps/element.png"

      # executable wrapper
      # LD_PRELOAD workaround for sqlcipher not found: https://github.com/matrix-org/seshat/issues/102
      makeWrapper '${lib.getExe electron}' "$out/bin/${executableName}" \
        --set LD_PRELOAD ${sqlcipher}/lib/libsqlcipher.so \
        --add-flags "$out/share/element/app.asar" \
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
        exec = "${executableName} %u";
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

    passthru = {
      # run with: nix-shell ./maintainers/scripts/update.nix --argstr package element-desktop
      updateScript = ./update.sh;
    };

    meta = {
      description = "Feature-rich client for Matrix.org";
      homepage = "https://element.io/";
      changelog = "https://github.com/element-hq/element-desktop/blob/v${finalAttrs.version}/CHANGELOG.md";
      license = lib.licenses.agpl3Plus;
      teams = [ lib.teams.matrix ];
      inherit (electron.meta) platforms;
      mainProgram = "element-desktop";
    };
  }
)
