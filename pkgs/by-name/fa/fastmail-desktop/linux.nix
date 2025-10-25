{
  pname,
  version,
  src,
  passthru,
  meta,
  lib,
  stdenvNoCC,
  appimageTools,
  asar,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  electron,
  libXScrnSaver,
  libXtst,
  libappindicator,
  libgcc,
  musl,
  vips,
}:
let
  appimageContents = appimageTools.extract { inherit pname version src; };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version passthru;

  dontUnpack = true;
  dontBuild = true;

  strictDeps = true;

  nativeBuildInputs = [
    asar
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    libgcc
    musl
    vips
  ];

  libPath = lib.makeLibraryPath [
    libXScrnSaver
    libXtst
    libappindicator
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "fastmail";
      desktopName = "Fastmail";
      comment = "Email and calendar made better";
      icon = "fastmail";
      exec = "fastmail";
      terminal = false;
      startupWMClass = "Fastmail";
      categories = [
        "Email"
        "Office"
      ];
      mimeTypes = [
        "x-scheme-handler/fastmail"
        "x-scheme-handler/mailto"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt"
    cp -r --no-preserve=mode "${appimageContents}/resources" "$out/opt/fastmail"
    asar extract "$out/opt/fastmail/app.asar" "$out/opt/fastmail/app.asar.unpacked"
    rm "$out/opt/fastmail/app.asar"

    for res in 16 24 32 48 64 128 256 512 1024; do
      resdir="''${res}x''${res}"
      mkdir -p "$out/share/icons/hicolor/$resdir/apps"
      cp -r --no-preserve=mode \
        "${appimageContents}/usr/share/icons/hicolor/$resdir/apps/production.png" \
        "$out/share/icons/hicolor/$resdir/apps/fastmail.png"
    done

    makeWrapper "${electron}/bin/electron" "$out/bin/fastmail" \
      --add-flags "$out/opt/fastmail/app.asar.unpacked" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --prefix LD_LIBRARY_PATH : ${finalAttrs.libPath}:$out/opt/fastmail \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  meta = meta // {
    mainProgram = "fastmail";
  };
})
