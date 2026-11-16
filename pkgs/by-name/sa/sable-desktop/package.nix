{
  lib,
  stdenv,
  autoPatchelfHook,
  aws-lc,
  cargo,
  electron_45,
  libpulseaudio,
  makeWrapper,
  nodejs-slim,
  pipewire,
  pkg-config,
  pnpm_12,
  pnpmConfigHook,
  rustPlatform,
  rustc,
  sable-next-unwrapped,
  sqlite,
}:

let
  electron = electron_45;
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "sable-desktop";
  # the frontend and the vendored dependencies come from sable-next-unwrapped
  inherit (sable-next-unwrapped)
    version
    src
    pnpmDeps
    cargoDeps
    ;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    nodejs-slim
    pkg-config
    pnpm_12
    pnpmConfigHook
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    # cargoSetupHook makes aws-lc-sys and libsqlite3-sys use the system libraries
    aws-lc
    libpulseaudio
    pipewire
    sqlite
    # venmic, the prebuilt node module for screen share audio, links libstdc++
    (lib.getLib stdenv.cc.cc)
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    # takes over the app id and url schemes of sable 1, like upstream's stable builds
    SABLE_BUILD_FLAVOR = "stable";
    VERSION = finalAttrs.version;
  };

  buildPhase = ''
    runHook preBuild

    cp -r --no-preserve=mode ${sable-next-unwrapped} dist
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    pnpm --dir electron package --linux --dir \
      -c.electronDist="$PWD/electron-dist" \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sable
    cp -r electron/release/linux*-unpacked/resources/. $out/share/sable
    # tells the app that the package manager installs the desktop entry and the updates
    echo nix > $out/share/sable/package-type

    makeWrapper ${lib.getExe electron} $out/bin/sable \
      --add-flags $out/share/sable/app.asar \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --inherit-argv0

    install -Dm644 packaging/flatpak/moe.sable.client.desktop -t $out/share/applications
    for size in 32 64 128 256; do
      install -Dm644 packaging/flatpak/icons/''${size}x''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/moe.sable.client.png
    done

    runHook postInstall
  '';

  meta = {
    description = "Desktop client for Sable, a Matrix client";
    inherit (sable-next-unwrapped.meta) homepage changelog license;
    maintainers = with lib.maintainers; [
      bartoostveen
      fugi
      lashakamadadze
      toasteruwu
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # venmic ships as a prebuilt node module
      binaryNativeCode
    ];
    mainProgram = "sable";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
