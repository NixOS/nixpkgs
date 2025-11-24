{
  stdenv,
  copyDesktopItems,
  autoPatchelfHook,
  wrapGAppsHook4,
  makeDesktopItem,
  libusb1,
  webkitgtk_4_1,
  libsoup_3,
  pname,
  version,
  src,
  meta,
  ...
}:
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
    wrapGAppsHook4
  ];

  buildInputs = [
    libusb1
    webkitgtk_4_1
    libsoup_3
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -m755 -D keymapp "$out/bin/keymapp"
    install -Dm644 icon.png "$out/share/pixmaps/keymapp.png"

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(--set-default '__NV_PRIME_RENDER_OFFLOAD' 1)
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "keymapp";
      icon = "keymapp";
      desktopName = "Keymapp";
      categories = [
        "Settings"
        "HardwareSettings"
      ];
      type = "Application";
      exec = "keymapp";
    })
  ];
}
