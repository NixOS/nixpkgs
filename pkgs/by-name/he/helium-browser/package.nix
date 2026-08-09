{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  glib,
  gtk3,
  nss,
  nspr,
  alsa-lib,
  mesa,
  libdrm,
  libxkbcommon,
  libxkbfile,
  systemd,
  libglvnd,
  qt6,
}:

let
  pname = "helium-browser";
  version = "0.15.2.1";

  myBuildInputs = [
    glib
    gtk3
    nss
    nspr
    alsa-lib
    mesa
    libdrm
    libxkbcommon
    libxkbfile
    systemd
    libglvnd
    qt6.qtbase
  ];

  desktopItem = makeDesktopItem {
    name = "helium-browser";
    exec = "helium-browser %U";
    icon = "helium-browser";
    desktopName = "Helium-Browser";
    genericName = "Helium Browser";
    categories = [
      "Network"
      "WebBrowser"
    ];
  };
in
stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
    sha256 = "sha256-+Bw3Ty77cLQA8nBhx1gjyXFUjBbn4RMTU/D9Fc9DaKw=";
  };

  icon = fetchurl {
    url = "https://github.com/imputnet/helium/raw/main/resources/branding/app_icon/raw.png";
    sha256 = "sha256-dX8As09QbMdBlDf2KVHa10GecnCumWWPe1VLo6Ofnt0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = myBuildInputs;

  dontWrapQtApps = true;

  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/helium-browser
    cp -r . $out/opt/helium-browser

    mkdir -p $out/opt/helium-browser/resources/ublock
    if [ -d "resources/ublock" ]; then
      cp -r resources/ublock/. $out/opt/helium-browser/resources/ublock/
    elif [ ! -f "$out/opt/helium-browser/resources/ublock/managed_storage.json" ]; then
      echo '{}' > $out/opt/helium-browser/resources/ublock/managed_storage.json
    fi

    makeWrapper $out/opt/helium-browser/helium $out/bin/helium-browser \
         --set LD_LIBRARY_PATH "${lib.makeLibraryPath myBuildInputs}:$out/opt/helium-browser"

    mkdir -p $out/share/icons/hicolor/512x512/apps/
    cp ${icon} $out/share/icons/hicolor/512x512/apps/helium-browser.png

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/helium-browser.desktop $out/share/applications/
  '';

  meta = {
    description = "Privacy Focused Internet Browser";
    homepage = "https://github.com/imputnet/helium-linux";
    downloadPage = "https://github.com/imputnet/helium-linux/releases/";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ TylerNilson ];
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
