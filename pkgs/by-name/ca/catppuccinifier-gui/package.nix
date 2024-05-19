{
  lib,
  gtk3,
  glib,
  dbus,
  curl,
  wget,
  cairo,
  stdenv,
  librsvg,
  libsoup,
  fetchzip,
  openssl_3,
  webkitgtk,
  gdk-pixbuf,
  pkg-config,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
}:
let
  version = "8.0.0";
in
stdenv.mkDerivation {
  pname = "catppuccinifier-gui";
  inherit version;

  src = fetchzip {
    url = "https://github.com/lighttigerXIV/catppuccinifier/releases/download/${version}/Catppuccinifer-Linux-${version}.zip";
    hash = "sha256-fG6YhLsjvMUIWsOnm+GSOh6LclCAISPSRiDQdWLlAR4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    curl
    wget
    webkitgtk
    gtk3
    cairo
    gdk-pixbuf
    libsoup
    glib
    dbus
    openssl_3
    librsvg
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 installation-files/catppuccinifier-gui "$out/bin/catppuccinifier-gui"
    install -Dm644 installation-files/catppuccinifier.png "$out/share/pixmaps/catppuccinifier.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "catppuccinifier";
      name = "catppuccinifier";
      exec = "catppuccinifier-gui";
      icon = "catppuccinifier";
      comment = "Apply catppuccin flavors to your wallpapers";
    })
  ];

  meta = {
    description = "Apply catppuccin flavors to your wallpapers";
    homepage = "https://github.com/lighttigerXIV/catppuccinifier";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "catppuccinifier-gui";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
