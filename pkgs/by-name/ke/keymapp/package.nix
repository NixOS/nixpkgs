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
  undmg,
}:
let
  pname = "keymapp";
  version = "1.3.6";
  meta = {
    homepage = "https://www.zsa.io/flash/";
    description = "Application for ZSA keyboards";
    maintainers = with lib.maintainers; [
      jankaifer
      shawn8901
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.unfree;
  };

  linux = stdenv.mkDerivation (finalAttrs: {
    inherit pname version meta;

    src = fetchurl {
      url = "https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-${finalAttrs.version}.tar.gz";
      hash = "sha256-LWO4aeNmGgZ+T41pb6HwC3tnwaiGviDIq63QMsrlkEc=";
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

      install -m755 -D keymapp "$out/bin/keymapp"
      install -Dm644 icon.png "$out/share/pixmaps/keymapp.png"

      runHook postInstall
    '';

    preFixup = ''
      gappsWrapperArgs+=(--set-default '__NV_PRIME_RENDER_OFFLOAD' 1)
    '';

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
  });

  darwin = stdenv.mkDerivation (finalAttrs: {
    inherit pname version meta;

    src = fetchurl {
      # Upstream does not provide archives of previous versions,
      # therefore a capture using the wayback machine is used
      url = "https://web.archive.org/web/20250427080926/https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.dmg";
      hash = "sha256-sn8IkSV8AEqm8z/TiS1399hITBC9lnSSjQn/k0xWl6I=";
    };

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      mv Keymapp.app $out/Applications

      runHook postInstall
    '';
  });
in
if stdenv.hostPlatform.isDarwin then darwin else linux
