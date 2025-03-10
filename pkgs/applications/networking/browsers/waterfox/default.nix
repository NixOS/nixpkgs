{
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus-glib,
  libnotify,
  libdrm,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  libpulseaudio,
  gdk-pixbuf,
  gtk3,
  makeDesktopItem,
  unzip,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libxcb,
  writeText,
  patchelf,
  makeWrapper,
  libGL,
  ffmpeg,
  glib,
  pciutils, # Added for libpci.so
}:

let
  version = "6.5.4";

  desktopItem = makeDesktopItem {
    name = "waterfox";
    exec = "waterfox %U";
    icon = "waterfox";
    desktopName = "Waterfox";
    genericName = "Web Browser";
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeTypes = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
  };

  prefsFile = writeText "waterfox-prefs.js" ''
    // Disable automatic updates and notifications
    pref("app.update.auto", false);
    pref("app.update.enabled", false);
    pref("browser.crashReports.unsubmittedCheck.enabled", false);
  '';

in
stdenv.mkDerivation rec {
  pname = "waterfox";
  inherit version;

  src = fetchurl {
    url = "https://cdn1.waterfox.net/waterfox/releases/${version}/Linux_x86_64/waterfox-${version}.tar.bz2";
    sha256 = "d73a14315199a88d91b42b6d7f8dd6d427962d8a10d23c6717ac749f42292d0d";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    unzip
    patchelf
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus-glib
    libnotify
    libdrm
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
    libpulseaudio
    gdk-pixbuf
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxcb
    stdenv.cc.cc.lib
    libGL
    ffmpeg
    glib
    pciutils # Added here
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt,share/applications}
    cp -r . $out/opt/waterfox

    # Wrap the binary with LD_LIBRARY_PATH
    makeWrapper $out/opt/waterfox/waterfox-bin $out/bin/waterfox \
      --set GTK_IM_MODULE gtk-im-context-simple \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"

    # Install desktop file
    cp ${desktopItem}/share/applications/* $out/share/applications/

    # Install icon
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp $out/opt/waterfox/browser/chrome/icons/default/default256.png \
      $out/share/icons/hicolor/256x256/apps/waterfox.png

    # Install preferences
    mkdir -p $out/opt/waterfox/browser/defaults/preferences
    cp ${prefsFile} $out/opt/waterfox/browser/defaults/preferences/nix-prefs.js

    runHook postInstall
  '';

  postInstall = ''
    # Patch only dynamically linked .so files
    find $out/opt/waterfox -type f -name "*.so" -exec sh -c '
      if patchelf --print-interpreter "{}" >/dev/null 2>&1; then
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "${lib.makeLibraryPath buildInputs}:$out/opt/waterfox" \
          "{}"
      fi
    ' \;

    # Patch the main binary
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath buildInputs}:$out/opt/waterfox" \
      $out/opt/waterfox/waterfox-bin

    # Patch glxtest for GPU detection
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath buildInputs}:$out/opt/waterfox" \
      $out/opt/waterfox/glxtest

    # Patch vaapitest for video acceleration
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath buildInputs}:$out/opt/waterfox" \
      $out/opt/waterfox/vaapitst

    # Copy NSPR libraries
    cp -L ${nspr}/lib/libnspr4.so $out/opt/waterfox/
    cp -L ${nspr}/lib/libplc4.so $out/opt/waterfox/
    cp -L ${nspr}/lib/libplds4.so $out/opt/waterfox/

    # Copy NSS libraries if not already present
    for lib in ${nss}/lib/lib{nss3,nssutil3,smime3,ssl3}.so; do
      if [ ! -e $out/opt/waterfox/$(basename $lib) ]; then
        cp -L $lib $out/opt/waterfox/
      fi
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share"
    )
  '';

  meta =  {
    description = "Privacy-focused, multi-platform web browser";
    homepage = "https://www.waterfox.net/";
    license = lib.licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ joyfulcat ];
  };
}
