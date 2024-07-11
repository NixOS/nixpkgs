{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook4,
  libusb1,
  libsoup_3,
  webkitgtk_4_1,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  desktopItem = makeDesktopItem {
    name = "keymapp";
    icon = "keymapp";
    desktopName = "Keymapp";
    categories = [
      "Settings"
      "HardwareSettings"
    ];
    type = "Application";
    exec = "keymapp";
  };
in
stdenv.mkDerivation rec {
  pname = "keymapp";
  version = "1.3.0";

  src = fetchurl {
    url = "https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-${version}.tar.gz";
    hash = "sha256-kl/2faWbn1sF7AzgkyM6C9xzXTYh8HJf81xIY4Zf3IY=";
  };

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

    install -m755 -D keymapp "$out/bin/${pname}"
    install -Dm644 icon.png "$out/share/pixmaps/${pname}.png"

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(--set-default '__NV_PRIME_RENDER_OFFLOAD' 1)
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    homepage = "https://www.zsa.io/flash/";
    description = "Application for ZSA keyboards";
    maintainers = with lib.maintainers; [
      jankaifer
      shawn8901
    ];
    platforms = platforms.linux;
    license = lib.licenses.unfree;
  };
}
