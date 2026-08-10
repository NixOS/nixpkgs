{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  electron_42,
  cacert,
  makeDesktopItem,
  copyDesktopItems,
  commandLineArgs ? [ ],
  nix-update-script,
  _experimental-update-script-combinators,
  writeShellApplication,
  nix,
  curl,
  common-updater-scripts,
  jq,
  gnugrep,
}:

let
  electron = electron_42;
in
buildNpmPackage (finalAttrs: {
  pname = "shogihome";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "sunfish-shogi";
    repo = "shogihome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vo9ZxiTJNPBVOlylmXbBzVzXCEr++JZRgHyJ0JYYstY=";
  };

  npmDepsHash = "sha256-1LQIhHCTx8ZY2r/kwkd+qPM1FNo4dxx2jDDTtBscemY=";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail 'npm run install:esbuild && ' "" \
      --replace-fail 'npm run install:electron && ' ""

    substituteInPlace .electron-builder.config.mjs \
      --replace-fail 'AppImage' 'dir' \
      --replace-fail 'await signMacApp' '// await signMacApp'
  ''
  # Workaround for https://github.com/electron/electron/issues/31121
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/background/proc/env.ts \
      --replace-fail 'process.resourcesPath' "'$out/share/lib/shogihome/resources'"
  '';

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_build_from_source = "true";

  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Prevent "unable to get local issuer certificate" error
    NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";
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

    npm run electron:pack

    # Explicitly set identity to null to avoid signing on arm64 macs with newer electron-builder.
    # See: https://github.com/electron-userland/electron-builder/pull/9007

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
      (lib.getExe (writeShellApplication {
        name = "${finalAttrs.pname}-version-updater";

        runtimeInputs = [
          curl
          jq
          common-updater-scripts
        ];

        # Use release.json as the primary source rather than git tags or GitHub releases:
        # https://github.com/sunfish-shogi/shogihome/issues/1704#issuecomment-5105936699
        text = ''
          version="$(curl -s 'https://sunfish-shogi.github.io/shogihome/release.json' | jq -r '.latest.version')"
          update-source-version '${finalAttrs.pname}' "$version"
        '';
      }))
      # Update src.hash and npmDepsHash
      (nix-update-script {
        extraArgs = [
          "--version=skip"
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
          PKG_FILE = toString ./package.nix;
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
    license =
      with lib.licenses;
      AND [
        mit
        asl20 # for icons
      ];
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "shogihome";
  };
})
