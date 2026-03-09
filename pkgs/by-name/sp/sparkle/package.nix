{
  lib,
  stdenvNoCC,
  buildGoModule,
  fetchFromGitHub,
  pnpm_10,
  pnpm ? pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  makeWrapper,
  electron,
  dbip-asn-lite,
  dbip-country-lite,
  v2ray-geoip,
  v2ray-domain-list-community,
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
    version = "0-unstable-2025-10-24";

    src = fetchFromGitHub {
      owner = "xishang0128";
      repo = "sparkle-service";
      rev = "fb7006438d6335c7ee9fbf4530b1821428385cab";
      hash = "sha256-V1HwYbdUunLTWFhfW7EHDDkIQyKFq2mbUysndttIlTE=";
    };

    vendorHash = "sha256-1n4CJT7zh6uxg6fGAVQz/KVKqXelFoTtETFPARcbPb8=";

    meta.mainProgram = "sparkle-service";
  };
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sparkle";
  version = "1.26.2";

  src = fetchFromGitHub {
    owner = "xishang0128";
    repo = "sparkle";
    tag = finalAttrs.version;
    hash = "sha256-6/VdWVobiBjjggC215g/zZmVAx1EzGbPE6+xp6ekcJw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-P0KwmLwj1FIWBduT2DzOaRCYrbQ+kvcCdCgabAhmMm8=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm
    nodejs
    makeWrapper
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # workaround for https://github.com/electron/electron/issues/31121
  postPatch = ''
    sed -i "s#process\.resourcesPath#'$out/lib/sparkle/resources'#g" \
      src/main/utils/dirs.ts
  '';

  buildPhase = ''
    runHook preBuild

    npm exec electron-vite -- build
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/sparkle
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/lib/sparkle/

    install -D resources/icon.png $out/share/icons/hicolor/512x512/apps/sparkle.png

    mkdir -p $out/lib/sparkle/resources/{files,sidecar}
    ln -s ${sub-store-frontend} $out/lib/sparkle/resources/files/sub-store-frontend
    ln -s ${sub-store}/share/sub-store/sub-store.bundle.js $out/lib/sparkle/resources/files/sub-store.bundle.js
    ln -s ${dbip-asn-lite.mmdb} $out/lib/sparkle/resources/files/ASN.mmdb
    ln -s ${dbip-country-lite.mmdb} $out/lib/sparkle/resources/files/country.mmdb
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/sparkle/resources/files/geoip.dat
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/lib/sparkle/resources/files/geosite.dat
    ln -s ${lib.getExe sparkle-service} $out/lib/sparkle/resources/files/sparkle-service
    ln -s ${lib.getExe mihomo} $out/lib/sparkle/resources/sidecar/mihomo

    makeWrapper '${lib.getExe electron}' $out/bin/sparkle \
      --add-flags $out/lib/sparkle/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Another Mihomo GUI";
    homepage = "https://github.com/xishang0128/sparkle";
    license = lib.licenses.gpl3Plus;
    mainProgram = "sparkle";
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.linux;
  };
})
