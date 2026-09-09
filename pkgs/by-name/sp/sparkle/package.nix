{
  lib,
  stdenvNoCC,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  electron,
  dbip-asn-lite, # asn.mmdb
  dbip-country-lite, # country.mmdb
  v2ray-geoip, # geoip.dat
  v2ray-domain-list-community, # geosite.dat
  sub-store,
  sub-store-frontend,
  mihomo,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

let
  sparkle-service = buildGoModule {
    pname = "sparkle-service";
    version = "0-unstable-2026-08-02";

    src = fetchFromGitHub {
      owner = "xishang0128";
      repo = "sparkle-service";
      rev = "3cabb61aaf446444d71acbe06a3abdd768d2e80e";
      hash = "sha256-djXVcBDf5whSM6U0qBydFeX+XbHnmKTVGDet6aA3a1g=";
    };

    vendorHash = "sha256-GXAP6pCKyy41UyMfz1X9F8GeAbyYZi4suPXDryKINOU=";

    meta.mainProgram = "sparkle-service";
  };

  resourcesDir =
    if stdenvNoCC.hostPlatform.isDarwin then
      "$out/Applications/Sparkle.app/Contents/Resources"
    else
      "$out/share/sparkle/resources";
in

buildNpmPackage (finalAttrs: {
  pname = "sparkle";
  version = "1.26.7";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xishang0128";
    repo = "sparkle";
    tag = finalAttrs.version;
    hash = "sha256-R9FVlt0rLxgIpeIJbwoIIYPmpP3LKoRWyt7u4ohbN4E=";
  };

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-hSozWInESlJhEjNKbVLgRJG+G7dFgFb+834rugHh05c=";
  };

  nativeBuildInputs = [
    pnpm
    makeWrapper
    copyDesktopItems
  ];
  npmConfigHook = pnpmConfigHook;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # workaround for https://github.com/electron/electron/issues/31121
  postPatch = ''
    substituteInPlace src/main/utils/dirs.ts \
      --replace-fail "process.resourcesPath" "'${resourcesDir}'"
  '';

  buildPhase = ''
    runHook preBuild

    npm exec electron-vite -- build

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenvNoCC.hostPlatform.isDarwin then
        ''
          mkdir -p $out/{Applications,bin}
          cp -r dist/mac*/Sparkle.app $out/Applications
          makeWrapper $out/Applications/Sparkle.app/Contents/MacOS/Sparkle $out/bin/sparkle
        ''
      else
        ''
          mkdir -p $out/share/sparkle
          install -D resources/icon.png $out/share/icons/hicolor/512x512/apps/sparkle.png
          cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/sparkle/
          makeWrapper ${lib.getExe electron} $out/bin/sparkle \
            --add-flags $out/share/sparkle/resources/app.asar \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
            --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
            --set-default ELECTRON_IS_DEV 0 \
            --inherit-argv0
        ''
    }

    mkdir -p ${resourcesDir}/{files,sidecar}
    ln -s ${sub-store-frontend} ${resourcesDir}/files/sub-store-frontend
    ln -s ${sub-store}/share/sub-store/sub-store.bundle.js ${resourcesDir}/files/sub-store.bundle.js
    ln -s ${dbip-asn-lite.mmdb} ${resourcesDir}/files/ASN.mmdb
    ln -s ${dbip-country-lite.mmdb} ${resourcesDir}/files/country.mmdb
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat ${resourcesDir}/files/geoip.dat
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat ${resourcesDir}/files/geosite.dat
    ln -s ${lib.getExe sparkle-service} ${resourcesDir}/files/sparkle-service
    ln -s ${lib.getExe mihomo} ${resourcesDir}/sidecar/mihomo

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "sparkle";
      desktopName = "Sparkle";
      exec = "sparkle %U";
      terminal = false;
      type = "Application";
      icon = "sparkle";
      startupWMClass = "sparkle";
      comment = "Another Mihomo GUI";
      categories = [
        "Utility"
        "Network"
      ];
      mimeTypes = [
        "x-scheme-handler/clash"
        "x-scheme-handler/mihomo"
        "x-scheme-handler/sparkle"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Another Mihomo GUI";
    homepage = "https://github.com/xishang0128/sparkle";
    license = lib.licenses.gpl3Plus;
    mainProgram = "sparkle";
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
