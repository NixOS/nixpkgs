{
  lib,
  stdenv,
  nodejs,
  fetchFromGitHub,
  fetchPnpmDeps,
  electron_43,
  pnpmConfigHook,
  pnpm_10,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  faketty,
  makeWrapper,
  jq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iptvnator";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "4gray";
    repo = "iptvnator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LKLM9SQ7TJCmsH2cDN4GAkTbvMtEfsDA3y40i4dGqJs=";
  };

  patches = [
    # better-sqlite3 13.0.3 is needed to build against Electron 43; hand-ported
    # because upstream's equivalent change (https://github.com/4gray/iptvnator/pull/1415)
    # does not apply to the v0.22.0 manifests.
    ./better-sqlite3-13.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit (finalAttrs) patches;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-b6v8hCZy/H06n4RceS/x3xFACdP0czAokwRl8xXQ1gI=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    nodejs
    nodejs.python
    pnpmConfigHook
    pnpm_10
    faketty
    makeWrapper
    jq
    copyDesktopItems
  ];

  dontStrip = true;

  postPatch = ''
    # embedded MPV requires vendored binaries; skip and use system mpv instead
    cat > apps/electron-backend/build-embedded-mpv.js << 'EOF'
    #!/usr/bin/env node
    console.log("[embedded-mpv] Skipping embedded MPV build; using system mpv instead.");
    EOF

    # webpack references native/build/Release in its assets config; create it
    mkdir -p apps/electron-backend/native/build/Release
    touch apps/electron-backend/native/build/Release/.empty

    rm -f apps/electron-backend/src/app/options/electron-builder.metadata.generated.json
  '';

  preConfigure = ''
    export HOME="$NIX_BUILD_TOP/home"
    mkdir -p "$HOME"

    cp -rL "${electron_43.dist}" "$HOME/.electron-dist"
    chmod -R u+w "$HOME/.electron-dist"
  '';

  preBuild = ''
    export npm_config_nodedir=${electron_43.headers}
    export npm_config_build_from_source=true
  '';

  # faketty is required to work around a bug in nx.
  # See: https://github.com/nrwl/nx/issues/22445
  buildPhase = ''
    runHook preBuild

    faketty pnpm run build:backend

    runHook postBuild
  '';

  postBuild = ''
    # Override electron-builder config: use local electron dist, pin version, dir-only for linux
    jq --arg dist "$HOME/.electron-dist" \
       --arg ver "${electron_43.version}" \
       '. + {electronDist: $dist, electronVersion: $ver}
        | .linux.target = [{"target": "dir", "arch": ["x64"]}]
        | .files = [
            {"from": "dist/apps/remote-control-web", "to": "remote-control-web", "filter": ["**/*"]},
            {"from": "dist/apps/electron-backend", "to": "electron-backend", "filter": ["**/*"]},
            {"from": "dist/apps/web", "to": "web", "filter": ["**/*"]},
            "!**/*.map"
          ]' \
       electron-builder.json > dist/electron-builder.nix.json

    npm exec electron-builder -- \
      --dir \
      --config dist/electron-builder.nix.json \
      -c.linux.executableName=iptvnator
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/iptvnator $out/bin

    linuxDir=$(echo dist/executables/linux*-unpacked)
    if [ ! -d "$linuxDir" ]; then
      echo "ERROR: electron-builder output directory not found: $linuxDir" >&2
      exit 1
    fi
    cp -r "$linuxDir"/{locales,resources{,.pak}} $out/share/iptvnator/

    makeWrapper ${lib.getExe electron_43} $out/bin/iptvnator \
      --add-flags $out/share/iptvnator/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --set ELECTRON_IS_DEV 0 \
      --inherit-argv0

    for s in 16 32 48 64 128 1024; do
      icon_path="apps/web/src/assets/icons/icon-$s.png"
      if [ -f "$icon_path" ]; then
        install -Dm644 "$icon_path" "$out/share/icons/hicolor/''${s}x$s/apps/iptvnator.png"
      fi
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "iptvnator";
      desktopName = "IPTVnator";
      exec = "iptvnator %U";
      icon = "iptvnator";
      comment = "Cross-platform IPTV player application";
      categories = [
        "AudioVideo"
        "Video"
      ];
      startupWMClass = "iptvnator";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform IPTV player application with support for m3u/m3u8 playlists, favorites, TV guide, and TV archive/catchup";
    homepage = "https://github.com/4gray/iptvnator";
    maintainers = with lib.maintainers; [ subham-roy ];
    changelog = "https://github.com/4gray/iptvnator/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "iptvnator";
    platforms = lib.platforms.linux;
  };
})
