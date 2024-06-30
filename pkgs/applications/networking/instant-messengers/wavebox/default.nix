{ autoPatchelfHook
, fetchurl
, makeDesktopItem
, makeShellWrapper
, makeWrapper
, wrapGAppsHook3
, alsa-lib
, atk
, cairo
, cups
, gtk3
, lib
, mesa
, nspr
, nss
, pango
, stdenv
, udev
, xdg-utils
, xorg
}:

stdenv.mkDerivation rec {
  pname = "wavebox";
  version = "10.125.28-2";

  src = fetchurl {
    url = "https://download.wavebox.app/stable/linux/tar/Wavebox_${version}.tar.gz";
    sha256 = "sha256-8X17WLa1q2c7FQD61e5wYZKOYnHA9sSvfGrtARACGZc=";
  };

  dontBuild = true;
  dontConfigure = true;
  # Avoid double-wrapping
  dontWrapGApps = true;
  # Ignore the unused Qt shims
  autoPatchelfIgnoreMissingDeps = [ "libQt5Widgets.so.5" "libQt5Gui.so.5" "libQt5Core.so.5" "libQt6Widgets.so.6" "libQt6Gui.so.6" "libQt6Core.so.6" ];
  nativeBuildInputs = [ autoPatchelfHook (wrapGAppsHook3.override { makeWrapper = makeShellWrapper; }) ];

  buildInputs = [
    alsa-lib
    atk
    cairo
    cups
    pango
    mesa
    nspr
    nss
    xorg.libXrandr
  ];

  runtimeDependencies = [ alsa-lib gtk3 mesa nspr nss (lib.getLib udev) ];

  desktopItems = [
    (makeDesktopItem rec {
      name = "Wavebox";
      exec = "wavebox";
      icon = "wavebox";
      desktopName = name;
      genericName = name;
      categories = [ "Network" "WebBrowser" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/wavebox
    cp -r * $out/opt/wavebox

    # provide icon for desktop item
    mkdir -p $out/share/icons/hicolor/128x128/apps
    ln -s $out/opt/wavebox/product_logo_128.png $out/share/icons/hicolor/128x128/apps/wavebox.png

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(--add-flags "--disable-features=AllowQt \''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}")
  '';

  postFixup = ''
    makeWrapper $out/opt/wavebox/wavebox $out/bin/wavebox \
      --prefix PATH : ${xdg-utils}/bin \
      "''${gappsWrapperArgs[@]}"
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Wavebox messaging application";
    homepage = "https://wavebox.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ flexiondotorg rawkode ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}
