{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  electron_37,
  vulkan-loader,
  makeDesktopItem,
  copyDesktopItems,
  commandLineArgs ? [ ],
  nix-update-script,
  _experimental-update-script-combinators,
  writeShellApplication,
  nix,
  jq,
  gnugrep,
}:

let
  electron = electron_37;
in
buildNpmPackage (finalAttrs: {
  pname = "shogihome";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "sunfish-shogi";
    repo = "shogihome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qa8ykN514Moc/PpBhD/X+mzfclQPp3yiriwTJCtmMA8=";
  };

  npmDepsHash = "sha256-rcrj3dG96oNbmp3cXw1qRJPi1SZdBcG9paAShSfb/0E=";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail 'npm run install:esbuild && ' "" \
      --replace-fail 'npm run install:electron && ' ""

    substituteInPlace .electron-builder.config.mjs \
      --replace-fail 'AppImage' 'dir'
  ''
  # Workaround for https://github.com/electron/electron/issues/31121
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/background/window/path.ts \
      --replace-fail 'process.resourcesPath' "'$out/share/lib/shogihome/resources'"
  '';

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_build_from_source = "true";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    makeWrapper
    copyDesktopItems
  ];

  makeCacheWritable = true;

  dontNpmBuild = true;

  buildPhase = ''
    runHook preBuild

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
  ''
  # Electron builder complains about symlink in electron-dist
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    rm electron-dist/libvulkan.so.1
    cp '${lib.getLib vulkan-loader}/lib/libvulkan.so.1' electron-dist
  ''
  # Explicitly set identity to null to avoid signing on arm64 macs with newer electron-builder.
  # See: https://github.com/electron-userland/electron-builder/pull/9007
  + ''
    npm run electron:pack

    ./node_modules/.bin/electron-builder \
        --dir \
        --config .electron-builder.config.mjs \
        -c.mac.identity=null \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p "$out/share/lib/shogihome"
    cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/shogihome"

    install -Dm444 'docs/icon.svg' "$out/share/icons/hicolor/scalable/apps/shogihome.svg"

    makeWrapper '${lib.getExe electron}' "$out/bin/shogihome" \
      --add-flags "$out/share/lib/shogihome/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArgs commandLineArgs} \
      --inherit-argv0
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv dist/mac*/ShogiHome.app "$out/Applications"
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "shogihome";
      exec = "shogihome %U";
      icon = "shogihome";
      desktopName = "ShogiHome";
      genericName = "Shogi Frontend";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];

      # The project was renamed "shogihome" from "electron-shogi."
      # Some references to "electron-shogi" remain for compatibility.
      # ref: https://github.com/sunfish-shogi/shogihome/commit/e5bbc4d43d231df23ac31c655adb64e11890993e
      startupWMClass = "electron-shogi";
    })
  ];

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [
          "--version-regex=^v([\\d\\.]+)$"
        ];
      })
      (lib.getExe (writeShellApplication {
        name = "${finalAttrs.pname}-electron-updater";
        runtimeInputs = [
          nix
          jq
          gnugrep
        ];
        runtimeEnv = {
          PNAME = finalAttrs.pname;
          PKG_FILE = builtins.toString ./package.nix;
        };
        text = ''
          new_src="$(nix-build --attr "pkgs.$PNAME.src" --no-out-link)"
          new_electron_major="$(jq '.devDependencies.electron' "$new_src/package.json" | grep --perl-regexp --only-matching '\d+' | head -n 1)"
          sed -i -E "s/electron_[0-9]+/electron_$new_electron_major/g" "$PKG_FILE"
        '';
      }))
    ];
  };

  meta = {
    description = "Shogi frontend supporting USI engines";
    homepage = "https://sunfish-shogi.github.io/shogihome/";
    license = with lib.licenses; [
      mit
      asl20 # for icons
    ];
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "shogihome";
  };
})
