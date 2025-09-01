{
  stdenv,
  lib,
  fetchurl,
  callPackage,
  autoPatchelfHook,
  wrapGAppsHook4,
  libusb1,
  libsoup_3,
  webkitgtk_4_1,
  makeDesktopItem,
  copyDesktopItems,
  undmg,
}:
let
  pname = "keymapp";
  version = "1.3.7";

  sources = rec {
    aarch64-darwin = {
      # Upstream does not provide archives of previous versions,
      # therefore a capture using the wayback machine is used
      url = "https://web.archive.org/web/20250520135916/https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.dmg";
      hash = "sha256-H6xRau7pWuSF5Aa6lblwi/Lg5KxC+HM3rtUMjX+hEE8=";
    };
    x86_64-darwin = aarch64-darwin;
    aarch64-linux = {
      url = "https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-${version}.tar.gz";
      hash = "sha256-qHvHCDzWRhuhDg2kuU8kmikQDXElQtVEmPAelHz4aPo=";
    };
    x86_64-linux = aarch64-linux;
  };
  src = fetchurl {
    inherit (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}")) url hash;
  };

  meta = {
    homepage = "https://www.zsa.io/flash/";
    description = "Application for ZSA keyboards";
    maintainers = with lib.maintainers; [
      afh
      jankaifer
      shawn8901
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
  };

in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      src
      meta
      undmg
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      src
      meta
      libusb1
      libsoup_3
      webkitgtk_4_1
      autoPatchelfHook
      wrapGAppsHook4
      copyDesktopItems
      makeDesktopItem
      ;
  }
