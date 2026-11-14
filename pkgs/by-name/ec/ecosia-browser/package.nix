{
  lib,
  stdenv,
  fetchurl,
  squashfsTools,
  makeWrapper,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  patchelf,
  glib,
  nspr,
  nss,
  atk,
  cups,
  dbus,
  gdk-pixbuf,
  gtk3,
  pango,
  cairo,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  alsa-lib,
  mesa,
  systemd,
  libdrm,
  libxkbcommon,
  expat,
  at-spi2-atk,
  at-spi2-core,
  adwaita-icon-theme,
  gsettings-desktop-schemas,

  pname ? "ecosia-browser",
  version ? "stable",
  url ? "https://api.snapcraft.io/api/v1/snaps/download/2MakkUunZD1vJLykl5QmmVDQAZdE84wY_3.snap",
  sha256 ? "0xabiis0plhwc420irkkb8wn0s3clx38vbdhxglnkf4zp145sf41",
  desktopName ? "Ecosia Browser",

  commandLineArgs ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    name = "${pname}.snap";
    inherit url sha256;
  };

  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
  ];

  nativeBuildInputs = [
    squashfsTools
    makeWrapper
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    glib
    nspr
    nss
    atk
    cups
    dbus
    gdk-pixbuf
    gtk3
    pango
    cairo
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    alsa-lib
    mesa
    systemd
    libdrm
    libxkbcommon
    expat
    at-spi2-atk
    at-spi2-core
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    unsquashfs $src
  '';

  installPhase = ''
    runHook preInstall

    rpath="${lib.makeLibraryPath finalAttrs.buildInputs}"

    mkdir -p $out/share/ecosia
    cp -r squashfs-root/opt/ecosia/* $out/share/ecosia/

    mkdir -p $out/share/icons/hicolor/scalable/apps
    if [ -f squashfs-root/app/share/icons/hicolor/scalable/apps/org.ecosia.Browser.svg ]; then
      cp squashfs-root/app/share/icons/hicolor/scalable/apps/org.ecosia.Browser.svg \
         $out/share/icons/hicolor/scalable/apps/ecosia.svg
    fi

    mkdir -p $out/bin
    makeWrapper $out/share/ecosia/chrome $out/bin/ecosia \
      --prefix LD_LIBRARY_PATH : "$rpath:$out/share/ecosia" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:${adwaita-icon-theme}/share" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    for elf in $out/share/ecosia/{chrome,chrome-sandbox,chrome_crashpad_handler}; do
      if [ -f "$elf" ]; then
        patchelf --set-rpath "$rpath:$out/share/ecosia" "$elf" || true
      fi
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ecosia";
      exec = "ecosia %U";
      icon = "ecosia";
      desktopName = "Ecosia Browser";
      genericName = "Web Browser";
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeTypes = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    })
  ];

  meta = with lib; {
    description = "The greenest browser on Earth";
    homepage = "https://www.ecosia.org/browser";
    license = lib.licenses.unfree;
    mainProgram = "ecosia";
    maintainers = with lib.maintainers; [ _2hexed ];
    platforms = [ "x86_64-linux" ];
  };
})
